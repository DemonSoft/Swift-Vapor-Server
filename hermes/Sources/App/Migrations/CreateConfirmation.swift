//
//  CreateConfirmation.swift
//  
//
//  Created by Dmitriy Soloshenko on 31.03.2023.
//

import Fluent

extension Confirmation {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("confirmations")
                .id()
                .field("user_id",       .uuid,   .required, .references("users", "id"))
                .field("exp",           .int64,  .required)
                .field("operation",     .string, .required)
                .field("payload",       .string)
                .field("created_at",    .datetime)
                .field("updated_at",    .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("confirmations").delete()
        }
    }
}

