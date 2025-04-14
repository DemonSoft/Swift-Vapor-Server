//
//  CreateImages.swift
//  
//
//  Created by Dmitriy Soloshenko on 25.03.2023.
//

import Fluent

extension Image {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("images")
                .id()
                .field("profile_id",    .uuid,   .required, .references("profiles", "id"))
                .field("path",          .string, .required)
                .field("exp",           .int64)
                .field("kind",          .string, .required)
                .field("created_at",    .datetime)
                .field("updated_at",    .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("images").delete()
        }
    }
}
