//
//  CerberusMiddleware.swift
//  
//
//  Created by Dmitriy Soloshenko on 19.03.2023.
//

import Vapor
import Fluent

final class CerberusMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard request.headers.contains(name: Constants.xTokenHeader),
              let value = request.headers[Constants.xTokenHeader].first,
              value == Constants.xTokenValue
        else { throw self.exception(request) }
        
        return try await next.respond(to: request)
    }
    
    private func exception(_ request: Request) -> Abort {
        let errorResponse = Response(status: .forbidden)
        let message = "This API isn't accessible for public using."
        errorResponse.body = .init(string: message)
        return Abort(.badRequest, reason: message)
    }
}
