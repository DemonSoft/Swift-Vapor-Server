//
//  CreateUsers.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent

extension User {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("users")
                .id()
                .field("email",       .string, .required)
                .field("password",    .string, .required)
                .field("social_id",   .string)
                .field("profile_id",  .uuid,   .required, .references("profiles", "id"))
                .field("created_at",  .datetime)
                .field("updated_at",  .datetime)
                .field("deleted_at",  .datetime)
                .unique(on: "email")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("users").delete()
        }
    }
}
