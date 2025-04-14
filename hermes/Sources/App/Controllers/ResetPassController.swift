//
//  ResetPassController.swift
//  
//
//  Created by Dmitriy Soloshenko on 31.03.2023.
//

import Fluent
import Vapor

struct ResetPassController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.root.grouped("users")
        users.group("reset") { repair in
            repair.post(use: restorePassStart)
            repair.put(use: restorePassEnd)
        }
    }
    
    // POST: Start repair password
    func restorePassStart(req: Request) async throws -> Response {
        struct DTO : Content {
            let email:String
        }
        
        guard let dto   = try? req.content.decode(DTO.self) else {
            return Response.fail(Mistakes.userNotFound)
        }
        
        guard let user = try await User.query(on: req.db)
                                       .filter(\.$email == dto.email)
                                       .first(),
              let userId = user.id else {
            return Response.fail(Mistakes.userNotFound)
        }

        let uts = Int64(Date().addSeconds(Constants.lifetimePass).timeIntervalSince1970)
        let repair = Confirmation(id: UUID(), user: userId, exp: uts, operation: .restore_pass)
        guard let token = repair.id?.uuidString else {
            return Response.fail(Mistakes.cannotRepair)
        }
        
        try await repair.save(on: req.db)
        let profile = try await user.me(req)
        try await Mailer.sendRepairLink(req, dto.email, profile.fullName, token)

        return Response.success("OK")
    }
    
    // PUT: Finish repair password
    func restorePassEnd(req: Request) async throws -> Response {
        struct DTO : Content {
            let password:String
            let token: UUID
        }

        guard let dto   = try? req.content.decode(DTO.self) else {
            return Response.fail(Mistakes.userNotFound)
        }
        
        guard let record = try await Confirmation.query(on: req.db)
                                                 .filter(\.$id == dto.token)
                                                 .first(),
              record.exp < Int64(Date().timeIntervalSince1970)  else {
            return Response.fail(Mistakes.userNotFound)
        }

        let userId = record.$user.id
        guard let user = try await User.query(on: req.db)
                                       .filter(\.$id == userId)
                                       .first() else {
            return Response.fail(Mistakes.userNotFound)
        }

        let newPassword = try Bcrypt.hash(dto.password)
        user.password = newPassword

        try await req.db.transaction { db in
            try await user.save(on: db)
            try await record.delete(on: db)
        }
        
        return Response.success("OK")
    }
}
