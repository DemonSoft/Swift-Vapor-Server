//
//  CreateUserToken.swift
//  
//
//  Created by Dmitriy Soloshenko on 18.03.2023.
//

import Fluent

extension UserToken {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("user_tokens")
                .id()
                .field("value",       .string, .required)
                .field("exp",         .int64)
                .field("user_id",     .uuid,   .required, .references("users", "id"))
                .field("created_at",  .datetime)
                .field("updated_at",  .datetime)
                .unique(on: "value")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("user_tokens").delete()
        }
    }
}
