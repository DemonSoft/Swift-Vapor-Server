//
//  UserController.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent
import Vapor
import JWT
import JWTKit

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.root.grouped("users")
        users.post(use: create)
        users.put(use: restore)

        users.group("apple") { apple in
            apple.post(use: appleReg)
            apple.get(":id", use: appleAuth)
        }

        users.group("google") { apple in
            apple.post(use: googleAuth)
        }

        let basicMV   = User.authenticator()
        let guardMW   = User.guardMiddleware()
        let basicProtected = users.grouped(basicMV, guardMW)
        basicProtected.post("auth", use: login)
        
        let tokenProtected = users.grouped(UserToken.authenticator())
        tokenProtected.group("login") { login in
            login.post(use: update_login)
            login.put(use: confirm_login)
        }

        tokenProtected.group("account") { login in
            login.delete(use: remove)
        }

        tokenProtected.group("password") { pass in
            pass.put(use: update_pass)
        }
    }
    
    // POST: Create user
    func create(req: Request) async throws -> Response {
        
        struct DTO: Content {
            let email: String
            let password: String
        }

        // Extract DTO object from content
        let dto     = try req.content.decode(DTO.self)
        
        // Create default profile
        let profileId      = UUID()
        let profile        = Profile(id: profileId, nickname: self.createNickname())
        
        // First account is owner
        if try await User.query(on: req.db).count() == 0 {
            profile.role = .owner
        }

        // Create encrypted password
        let password = try Bcrypt.hash(dto.password)

        // Create user
        let user      = User(email: dto.email, password: password, profile: profileId)
        
        try await req.db.transaction { db in
            try await profile.save(on: db)
            try await user.save(on: db)
        }
        
        return try await user.retrieveBearer(req)
    }
    
    // POST: Sign In
    func login(req: Request) async throws -> Response {
        let user  = try req.user()
        return try await user.retrieveBearer(req)
    }

    // POST: Update login
    func update_login(req: Request) async throws -> Response {
        struct DTO : Content {
            let email:String
        }
        let dto   = try req.content.decode(DTO.self)

        guard let user = try? req.user(),
              let userId = user.id else {
            return Response.fail(Mistakes.unauthorized)
        }

        guard dto.email.count > 0,
              dto.email.trim.verification(.emailExpression, required: true) else  {
            return Response.fail(Mistakes.invalidEmail)
        }
        
        let uts = Int64(Date().addSeconds(Constants.lifetimePass).timeIntervalSince1970)
        let repair = Confirmation(id: UUID(), user: userId, exp: uts, operation: .change_login, payload: dto.email)
        guard let token = repair.id?.uuidString else {
            return Response.fail(Mistakes.cannotChange)
        }
        
        let profile = try await user.me(req)
        try await repair.save(on: req.db)
        try await Mailer.sendConfirmEmail(req, dto.email, profile.fullName, token)

        return Response.success("OK")
    }

    // PUT: Update login
    func confirm_login(req: Request) async throws -> Response {
        struct DTO : Content {
            let token: UUID
        }

        guard let dto   = try? req.content.decode(DTO.self) else {
            return Response.fail(Mistakes.cannotChange)
        }
        
        guard let record = try await Confirmation.query(on: req.db)
                                                 .filter(\.$id == dto.token)
                                                 .first(),
              record.exp < Int64(Date().timeIntervalSince1970)  else {
            return Response.fail(Mistakes.cannotChange)
        }

        let userId = record.$user.id
        guard let user = try await User.query(on: req.db)
                                       .filter(\.$id == userId)
                                       .first() else {
            return Response.fail(Mistakes.cannotChange)
        }

        guard let email = record.payload else {
            return Response.fail(Mistakes.cannotChange)
        }
        user.email = email

        try await req.db.transaction { db in
            try await user.save(on: db)
            try await record.delete(on: db)
        }
        
        return Response.success("OK")
    }

    // PUT: Update password
    func update_pass(req: Request) async throws -> Response {
        struct DTO : Content {
            let password: String
        }
        let dto   = try req.content.decode(DTO.self)

        guard let user = try? req.user() else {
            return Response.fail(Mistakes.unauthorized)
        }

        if dto.password.count > 0 {
            guard dto.password.count >= Constants.minimalPassword else {
                return Response.fail(Mistakes.invalidPass)
            }
            user.password = try Bcrypt.hash(dto.password)
        }

        try await user.save(on: req.db)
        return Response.success("OK")
    }
    
    // MARK -- Apple AUTH
    
    // Registration POST
    func appleReg(req: Request) async throws -> Response {
        struct DTO : Content {
            let id          : String
            let familyName  : String
            let givenName   : String
            let email       : String
        }

        // Extract DTO object from content
        let dto     = try req.content.decode(DTO.self)
        
        // Create default profile
        let profileId = UUID()
        let profile   = Profile(id: profileId)

        // First account is owner
        if try await User.query(on: req.db).count() == 0 {
            profile.role = .owner
        }
        
        if dto.familyName.count > 0 {
            profile.last_name = dto.familyName
        }

        if dto.givenName.count > 0 {
            profile.first_name = dto.givenName
            profile.nickname   = self.createNickname()
        }

        try await profile.save(on: req.db)
                
        // Create user
        let user      = User(email: dto.email, password: "<NO PASS>", socialId: dto.id, profile: profileId)
        
        let existUser = try await req.db.transaction { db in
            // Save user
            try await user.save(on: db)
            
            // Extract user
            let existUser = try await User.query(on: db).group(.and) { group in
                    group.filter(\.$email == dto.email)
                        .filter(\.$socialId == dto.id)
                        .filter(\.$profile.$id == profileId)
                }
                .first()
            
            guard let existUser else {
                throw Abort(.forbidden)
            }
            
            // Create encrypted password
            existUser.password = try self.socialPassById(dto.id)
            try await existUser.save(on: db)
            
            return existUser
        }
        
        return try await existUser.retrieveBearer(req)
    }
    
    // Authorization GET
    func appleAuth(req: Request) async throws -> Response {
        
        guard let appleId = req.parameters.get("id") else {
            throw Abort(.notFound)
        }

        guard let user = try await User.query(on: req.db)
            .filter(\.$socialId == appleId)
            .first() else {
            throw Abort(.notFound)
        }

        guard let password = try? self.socialPassById(appleId) else {
            throw Abort(.forbidden)
        }
        
        guard  user.password == password else {
            throw Abort(.notFound)
        }

        return try await user.retrieveBearer(req)
    }

    private func socialPassById(_ socialId: String) throws -> String {
        return try Bcrypt.hash(socialId, salt: Constants.bcryptSalt)
    }
    
    // MARK -- GOOGLE AUTH
    func googleAuth(req: Request) async throws -> Response {
        
        // Обработка токена
        let payload = try await self.extractGoogleJWTClaims(req: req)
        let password = try self.socialPassById(payload.sub)
        
        guard let user = try await User.query(on: req.db).group(.and, { group in
            group.filter(\.$email == payload.email)
                .filter(\.$socialId == payload.sub)
                .filter(\.$password == password)
        }).first() else {
            return try await self.googleRegistration(req: req, claims:payload)
        }

        return try await user.retrieveBearer(req)
    }
        
    private func createNickname() -> String {
        return "User-\(UInt16.random())"
    }
    
    private func extractGoogleJWTClaims(req: Request) async throws -> GoogleJWTClaims {
        struct DTO : Content {
            let token : String
        }
        // Extract DTO object from content
        let dto     = try req.content.decode(DTO.self)

        let jwksURI = URI("https://www.googleapis.com/oauth2/v3/certs")

        let response = try await req.client.get(jwksURI)
        guard response.status == .ok else {
            throw Abort(.internalServerError)
        }
        let jwks = try response.content.decode(JWKS.self)

        // Create signers and add JWKS.
        let signers = JWTSigners()
        try signers.use(jwks: jwks)
        
        return try signers.verify(dto.token, as: GoogleJWTClaims.self)
    }
    
    private func googleRegistration(req: Request, claims:GoogleJWTClaims) async throws -> Response {
        
        // Create default profile
        let profileId = UUID()
        let profile   = Profile(id: profileId)

        // First account is owner
        if try await User.query(on: req.db).count() == 0 {
            profile.role = .owner
        }
        
        if claims.familyName.count > 0 {
            profile.last_name = claims.familyName
        }

        if claims.givenName.count > 0 {
            profile.first_name = claims.givenName
            profile.nickname   = self.createNickname()
        }

        // Create user
        let user = User(email: claims.email, password: "<NO PASS>", socialId: claims.sub, profile: profileId)

        let existUser = try await req.db.transaction { db in
            try await profile.save(on: db)
            try await user.save(on: db)

            // Extract user
            let existUser = try await User.query(on: db).group(.and) { group in
                    group.filter(\.$email == claims.email)
                        .filter(\.$socialId == claims.sub)
                        .filter(\.$profile.$id == profileId)
                }
                .first()
            
            guard let existUser else {
                throw Abort(.forbidden)
            }
            
            // Create encrypted password
            existUser.password = try self.socialPassById(claims.sub)
            try await existUser.save(on: db)
            
            return existUser
        }
        
        return try await existUser.retrieveBearer(req)
    }
    
    func remove(req: Request) async throws -> Response {
        
        let user = try req.user()
        let me   = try await req.me()

        guard let userId = user.id else {
            return Response.fail(Mistakes.accountCannotDelete)
        }

        let uts = Int64(Date().addDays(days: Constants.restoreAcc).timeIntervalSince1970)
        
        let result =  try await req.db.transaction { db in
            
            let confirm = Confirmation(id: UUID(), user: userId, exp: uts, operation: .restore_acc, payload: nil)
            guard let token = confirm.id?.uuidString else {
                return Response.fail(Mistakes.cannotChange)
            }
            
            try await confirm.save(on: db)
            try await Mailer.sendDeleteAccount(req, user.email, me.fullName, token, uts)
            
            try await me.delete(on: db)
            try await user.delete(on: db)

            return Response.success(uts)
        }
        
        return result
    }

    func restore(req: Request) async throws -> Response {
        
        struct DTO : Content {
            let token: UUID
        }

        guard let dto   = try? req.content.decode(DTO.self) else {
            return Response.fail(Mistakes.accountCantRestore)
        }

        guard let record = try await Confirmation.query(on: req.db)
                                                 .filter(\.$id == dto.token)
                                                 .first(),
              record.exp > Int64(Date().timeIntervalSince1970)  else {
            return Response.fail(Mistakes.accountCantRestore)
        }

        guard let user = try await User.query(on: req.db)
                                       .withDeleted()
                                       .filter(\.$id == record.$user.id)
                                       .first() else {
            return Response.fail(Mistakes.accountCantRestore)
        }
        
        guard let profile = try await Profile.query(on: req.db)
                                       .withDeleted()
                                       .filter(\.$id == user.$profile.id)
                                       .first() else {
            return Response.fail(Mistakes.accountCantRestore)
        }

        let result =  try await req.db.transaction { db in

            try await user.restore(on: db)
            try await profile.restore(on: db)
            try await record.delete(force:true,  on: db)
            
            try await profile.save(on: db)
            try await user.save(on: db)

            return Response.success(profile.pub)
        }
        
        return result
    }
}
