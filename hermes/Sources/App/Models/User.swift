//
//  User.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent
import Vapor

final class User: Model, Content {
    static var schema: String = "users"

    @ID                         var id: UUID?
    @Field(key: "email")        var email: String
    @Field(key: "password")     var password: String
    @Field(key: "social_id")    var socialId: String?
    @Parent(key: "profile_id")  var profile: Profile
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?
    @Timestamp(key: "deleted_at", on: .delete)  var deletedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil,
         email: String,
         password: String,
         socialId: String? = nil,
         profile: Profile.IDValue) {
        self.id           = id
        self.email        = email
        self.password     = password
        self.socialId     = socialId
        self.$profile.id  = profile
    }
}
