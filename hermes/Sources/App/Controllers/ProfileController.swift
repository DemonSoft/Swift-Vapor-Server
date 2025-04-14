//
//  ProfileController.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent
import Vapor
import Foundation

struct ProfileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles = routes.root.grouped("users").grouped("profile")
        
        let protected = profiles.grouped(UserToken.authenticator())
        protected.get(use: me)
        protected.put(use: update)
        
        protected.group("wanted") { wanted in
            wanted.get(":id", use: wanted_profile)
        }
        
        protected.group("avatar") { avatar in
            avatar.get(use: getAvatar)
            avatar.post(use: updateAvatar)
        }
        
        protected.grouped(RolesMiddleware()).group("roles") { search in
            search.post(use: search_profiles)
            search.put(use: update_role)
        }
    }

    func me(req: Request) async throws -> Response {
        let profile = try await req.me()
        return Response.success(profile.pub)
    }
    
    func update(req: Request) async throws -> Response {
        let profile = try await req.me()
        
        let pub         = try req.content.decode(Profile.Public.self)
        profile.first_name  = pub.first_name
        profile.last_name   = pub.last_name
        profile.nickname    = pub.nickname
        profile.gender      = pub.gender
        profile.age         = pub.age
        try await profile.save(on: req.db)
        
        return Response.success(profile.pub)
    }

    // Gettings avatar
    func getAvatar(req: Request) async throws -> Response {
        let profile  = try await req.me()
        
        guard let id = profile.id else { return Response.fail(Mistakes.profileNotFound) }
        
        let imagePath = Image.avatarPath(req, id)
        let fileURL   = URL(fileURLWithPath: imagePath)
        let data      = try Data(contentsOf: fileURL)
        let response  = Response(status: .ok,
                                 headers: HTTPHeaders([("Content-Type", "image/png")]),
                                 body: Response.Body(data: data))
        
        return response
    }
    
    // Update avatar
    func updateAvatar(req: Request) async throws -> Response {
        struct DTO: Content {
            var image: Data
        }

        let profile  = try await req.me()
        guard let id = profile.id else { return Response.fail(Mistakes.profileNotFound) }

        guard let dto = try? req.content.decode(DTO.self) else {
            return Response.fail(Mistakes.imageIsWrong)
        }
        
        let byteBuffer = ByteBuffer(data: dto.image)
        let imageId    = UUID()
        let imagePath  = Image.avatarPath(req, id)
        let image      = Image(id:imageId, profile: id, path:imagePath, exp: Int64.max, kind: .avatar)
        
        try await req.fileio.writeFile(byteBuffer, at: imagePath)
        profile.avatar = imageId
        
        try await req.db.transaction({ db in
            try await image.save(on: db)
            try await profile.save(on: db)
        })
        
        return Response.success(profile.pub)
    }
    
    func search_profiles(req: Request) async throws -> Response {
        struct DTO : Content {
            let query: String
        }
        let dto   = try req.content.decode(DTO.self)
        let query = dto.query.lowercased()
        
        guard query.count > 0 else {
            return Response.fail(Mistakes.usersNotFound)
        }
        
        if let uuid = UUID(uuidString: query),
           let profile = try await Profile.query(on: req.db)
            .filter(\.$id == uuid)
            .first() {
            return Response.success([profile.pub])
        }

        var pubProfiles = [Profile.Public]()

        let users = try await User.query(on: req.db).filter(\.$email ~~ query).all()
        for user in users {
            let profile = try await user.me(req)
            pubProfiles += [profile.pub]
        }

        let profiles = try await Profile.query(on: req.db).filter(\.$nickname ~~ query).all().map{$0.pub}
        pubProfiles += profiles
        
        let role = try await req.me().role
        let uniqueElements = Array(Set(pubProfiles)).filter { role.greater(($0.role ?? .lowest)) }
        return Response.success(uniqueElements)
    }

    func update_role(req: Request) async throws -> Response {
        struct DTO : Content {
            let id: UUID
            let role: Role
        }
        
        let userProfile = try await req.me()
                
        guard let dto = try? req.content.decode(DTO.self),
              userProfile.role.greater(dto.role) else {
            return Response(status: .forbidden)
        }

        guard let profile = try await Profile.query(on: req.db)
                                       .filter(\.$id == dto.id)
                                       .first() else {
            return Response.fail(Mistakes.userNotFound)
        }
        
        guard userProfile.role.greater(profile.role)   else {
            return Response(status: .forbidden)
        }
        
        profile.role = dto.role
        try await profile.save(on: req.db)
        
        return Response.success(profile.pub)
    }
    
    func wanted_profile(req: Request) async throws -> Response {
        guard let profile = try await Profile.find(req.parameters.get("id"), on: req.db) else {
            return Response.fail(Mistakes.idNotFound)
        }
        
        return Response.success(profile.pub)
    }

}
