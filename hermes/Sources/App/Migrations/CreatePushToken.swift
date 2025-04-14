//
//  CreatePushToken.swift
//  
//
//  Created by Dmitriy Soloshenko on 14.04.2023.
//

import Fluent

extension PushToken {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("push_tokens")
                .id()
                .field("user_id",       .uuid,   .required, .references("users", "id"))
                .field("token",         .string, .required)
                .field("hash",          .string, .required)
                .field("used_at",       .datetime)
                .field("created_at",    .datetime)
                .field("updated_at",    .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("push_tokens").delete()
        }
    }
}

