//
//  Request.swift
//  
//
//  Created by Dmitriy Soloshenko on 22.04.2023.
//

import Fluent
import Vapor

extension Request {
    func user() throws -> User {
        return try self.auth.require(User.self)
    }

    func me() async throws -> Profile {
        let user = try user()
        return try await user.me(self)
    }
}
