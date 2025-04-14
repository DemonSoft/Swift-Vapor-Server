//
//  PushToken.swift
//  
//
//  Created by Dmitriy Soloshenko on 22.04.2023.
//

import Fluent
import Vapor

extension PushToken {
    
    static func tokens(_ req: Request) async throws -> [PushToken]  {
        let user = try req.user()
        guard let id = user.id else { return [PushToken]() }
        let tokens = try await PushToken.query(on: req.db)
            .filter(\.$user.$id == id)
            .all()

        return tokens
    }

    func countUnread(_ req: Request) async throws -> Int  {
        guard let id = self.id else { return 0 }
        let count = try await Push.query(on: req.db)
            .filter(\.$pushToken.$id == id)
            .count()
        return count
    }

    func pushes(_ req: Request) async throws -> [Push]  {
        guard let id = self.id else { return [] }
        let all = try await Push.query(on: req.db)
            .filter(\.$pushToken.$id == id)
            .all()
        return all
    }

}
