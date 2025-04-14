//
//  Product.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent
import Vapor
import StripeKit

final class Product: Model, Content, Encodable {
    
    static var schema: String = "products"

    @ID(key: .id)               var id: UUID?
    @Field(key: "name")         var name: String
    @Field(key: "weight")       var weight: Int
    @Field(key: "price")        var price: Int // Price in cents.
    @Enum(key: "currency")      var currency: StripeCurrency
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, weight: Int) {
        self.id = id
        self.name = name
        self.weight = weight
    }
}

