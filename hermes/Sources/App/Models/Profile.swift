//
//  Profile.swift
//  
//
//  Created by Dmitriy Soloshenko on 11.03.2023.
//

import Fluent
import Vapor

final class Profile: Model, Content {
    enum Gender: String, Codable {
        case unknown, male, female
    }

    static var schema: String = "profiles"

    @ID(key: .id)              var id: UUID?
    @Field(key: "first_name")  var first_name: String
    @Field(key: "last_name")   var last_name: String
    @Field(key: "nickname")    var nickname: String
    @Enum(key: "gender")       var gender: Gender
    @Field(key: "age")         var age: Int?
    @Enum(key: "role")         var role: Role
    @Field(key: "avatar")      var avatar: UUID?
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?
    @Timestamp(key: "deleted_at", on: .delete)  var deletedAt: Date?

    init() {}
    
    init(id: UUID = UUID(),
         first_name: String = "",
         last_name: String = "",
         nickname: String = "",
         gender: Gender = .unknown,
         age: Int? = nil,
         role: Role = .user,
         avatar: UUID? = nil) {
        self.id          = id
        self.first_name  = first_name
        self.last_name   = last_name
        self.nickname    = nickname
        self.gender      = gender
        self.age         = age
        self.role        = role
        self.avatar      = avatar
    }
    
    struct Public: Content, Encodable, Hashable {
        let id: UUID?
        let first_name: String
        let last_name: String
        let nickname: String
        let gender: Gender
        let age: Int?
        let role: Role?
        let avatar: UUID?
    }
}
