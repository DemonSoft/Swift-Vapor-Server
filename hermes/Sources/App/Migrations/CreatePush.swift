//
//  CreatePush.swift
//  
//
//  Created by Dmitriy Soloshenko on 14.04.2023.
//

import Fluent

extension Push {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("pushes")
                .id()
                .field("push_token_id", .uuid,   .required, .references("push_tokens", "id"))
                .field("title",         .string)
                .field("subtitle",      .string)
                .field("body",          .string)
                .field("payload",       .data)
                .field("read",          .bool)
                .field("created_at",    .datetime)
                .field("updated_at",    .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("pushes").delete()
        }
    }
}
