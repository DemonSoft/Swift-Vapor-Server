//
//  RolesMiddleware.swift
//  
//
//  Created by Dmitriy Soloshenko on 04.04.2023.
//

import Vapor
import Fluent

final class RolesMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let profile = try await request.me()
        guard profile.role.available(.manager) else {
            throw Abort (.forbidden)
        }
        
        return try await next.respond(to: request)
    }
}
