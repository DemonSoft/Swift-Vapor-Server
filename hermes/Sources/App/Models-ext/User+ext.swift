//
//  User.swift
//  
//
//  Created by Dmitriy Soloshenko on 22.04.2023.
//

import Fluent
import Vapor

extension User: ModelAuthenticatable  {
    static let usernameKey     = \User.$email
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
    
    func me(_ req: Request) async throws -> Profile  {
        guard let profile = try await Profile.query(on: req.db)
            .filter(\.$id == self.$profile.$id.wrappedValue)
            .first() else {
            throw Abort(.notFound)
        }

        return profile
    }
    
    func retrieveBearer(_ req: Request) async throws -> Response {
        // Create bearer token
        let token = try self.generateToken()
        try await token.save(on: req.db)

        Maintenance.start(req: req) // remove old tokens and confirmations
        
        let profile = try await self.me(req)

        // Send bearer token
        let response = Response.success(profile.pub)
        response.headers.add(name: Constants.xBearer, value: token.value)
        return response
    }
}
