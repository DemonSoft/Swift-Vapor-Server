//
//  UserToken.swift
//  
//
//  Created by Dmitriy Soloshenko on 18.03.2023.
//

import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "user_tokens"

    @ID(key: .id)               var id: UUID?
    @Field(key: "value")        var value: String
    @Parent(key: "user_id")     var user: User
    @Field(key: "exp")          var exp: Int64 // Unix date and time of token expiration
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, value: String, userID: User.IDValue, exp: Int64 = 0) {
        self.id       = id
        self.value    = value
        self.$user.id = userID
        self.exp      = Int64(Date().addDays(days: Constants.lifetime).timeIntervalSince1970)
    }
}
