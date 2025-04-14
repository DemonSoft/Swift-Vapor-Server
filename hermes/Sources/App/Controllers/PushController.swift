//
//  PushController.swift
//  
//
//  Created by Dmitriy Soloshenko on 14.04.2023.
//

import Fluent
import Vapor

struct PushController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.root.grouped("pushes")

        let protected = products.grouped(UserToken.authenticator())
        protected.put(use: update)
        protected.post(use: send)
        protected.get(use: list)
        
        protected.group("read") { repair in
            repair.get(":id", use: read)
        }
    }
    
    func update(req: Request) async throws -> Response {
        struct DTO: Content {
            var token: String
        }

        let dto   = try req.content.decode(DTO.self)
        let user  = try req.user()
        
        let hash = try self.createHash(dto.token)
        
        let pushTokens = try await PushToken.query(on: req.db)
            .filter(\.$hash == hash)
            .all()
        
        if pushTokens.count > 0 {
            return Response.fail(Mistakes.pushesRegistered)
        }
        
        guard let id = user.id else { return Response.fail(Mistakes.profileNotFound) }
        let record   = PushToken(user: id, token: dto.token, hash: hash)
        try await record.save(on: req.db)
        
        return Response.success("OK")
    }
    
    func send(req: Request) async throws -> Response {
        struct DTO: Content {
            var title: String
            var subtitle: String?
            var body: String?
        }

        let dto   = try req.content.decode(DTO.self)
        let tokens  = try await PushToken.tokens(req)
        
        if dto.title == dto.subtitle {
            return Response.fail(Mistakes.pushesCannotEqual)
        }
        
        try await PushSender().send(req:req, tokens: tokens, title: dto.title, subtitle: dto.subtitle, body: dto.body)
        
        return Response.success("OK")
    }
    
    func list(req: Request) async throws -> Response {

        let tokens  = try await PushToken.tokens(req)
        
        guard let last = tokens.max(count: 1,
                                    sortedBy: {($0.createdAt ?? Date.epoch) < ($1.createdAt ?? Date.epoch)})
            .first else { return Response.fail(nil, ["User cannot receive push notifications"]) }
        
        let messages = try await last.pushes(req).compactMap {$0.pub}
        
        return Response.success(messages)
    }

    func read(req: Request) async throws -> Response {
        guard let push = try await Push.find(req.parameters.get("id"), on: req.db) else {
            return Response.fail(Mistakes.idNotFound)
        }

        push.read = true
        try await push.save(on: req.db)
        return Response.success(push.pub)
    }

    private func createHash(_ token: String) throws -> String {
        return try Bcrypt.hash(token, salt: Constants.bcryptSalt)
    }

}

