//
//  CreateProducts.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent

extension Product {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("products")
                .id()
                .field("name",          .string, .required)
                .field("weight",        .int)
                .field("price",         .int)
                .field("currency",      .string, .required)
                .field("created_at",    .datetime)
                .field("updated_at",    .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("products").delete()
        }
    }
}
