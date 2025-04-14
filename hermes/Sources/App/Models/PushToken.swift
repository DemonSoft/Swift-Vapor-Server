//
//  PushToken.swift
//  
//
//  Created by Dmitriy Soloshenko on 14.04.2023.
//

import Fluent
import Vapor


final class PushToken: Model, Content {
    static let schema = "push_tokens"

    @ID(key: .id)               var id        : UUID?
    @Parent(key: "user_id")     var user      : User
    @Field(key:  "token")       var token     : String
    @Field(key:  "hash")        var hash      : String
    @Timestamp(key: "used_at"   , on: .none)  var used_at: Date?
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, user: User.IDValue, token: String, hash: String) {
        self.id          = id
        self.$user.id    = user
        self.token       = token
        self.hash        = hash
    }
}
