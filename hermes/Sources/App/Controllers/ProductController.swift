//
//  ProductController.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent
import Vapor

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.root.grouped("products")

        let protected = products.grouped(UserToken.authenticator())
        protected.get(use: index)
        protected.post(use: create)
        protected.put(":id", use: update)
        protected.delete(":id", use: delete)
    }
    
    func index(req: Request) async throws -> Response {
        try await Profile.auth(req)
        let products =  try await Product.query(on: req.db).all()
        return Response.success(products)
    }
    
    func create(req: Request) async throws -> Response {
        try await Profile.auth(req)
        guard let product = try? req.content.decode(Product.self) else {
            return Response.fail(Mistakes.iAmTeapot)
        }
        try await product.save(on: req.db)
        return Response.success(product)
    }

    func update(req: Request) async throws -> Response {
        try await Profile.auth(req)
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            return Response.fail(Mistakes.idNotFound)
        }
        
        let updated      = try req.content.decode(Product.self)
        product.name     = updated.name
        product.weight   = updated.weight
        product.price    = updated.price
        product.currency = product.currency
        try await product.save(on: req.db)
        
        return Response.success(product)
    }
    
    func delete(req: Request) async throws -> Response {
        try await Profile.auth(req)
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            return Response.fail(Mistakes.productCannotDelete)
        }
        try await product.delete(on: req.db)
        return Response.success("OK")
    }
}
