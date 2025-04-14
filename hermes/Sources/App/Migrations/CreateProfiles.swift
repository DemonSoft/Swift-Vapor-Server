//
//  CreateProfiles.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent

extension Profile {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("profiles")
                .id()
                .field("first_name",    .string, .required)
                .field("last_name",     .string, .required)
                .field("nickname",      .string, .required)
                .field("gender",        .string, .required)
                .field("age",           .int)
                .field("role",          .string, .required)
                .field("avatar",        .uuid)
                .field("created_at",    .datetime)
                .field("updated_at",    .datetime)
                .field("deleted_at",    .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("profiles").delete()
        }
    }
}
