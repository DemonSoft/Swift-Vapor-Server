//
//  Image.swift
//  
//
//  Created by Dmitriy Soloshenko on 25.03.2023.
//

import Fluent
import Vapor

final class Image: Model, Content {
    static let schema = "images"

    enum Kind: String, Codable {
        case regular, avatar
    }

    @ID(key: .id)              var id: UUID?
    @Parent(key: "profile_id") var profile: Profile
    @Field(key: "path")        var path: String // Local path on server file system
    @Field(key: "exp")         var exp: Int64? // Unix date and time of data expiration
    @Enum(key: "kind")         var kind: Kind
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, profile: Profile.IDValue, path: String, exp: Int64 = 0, kind: Kind = .regular) {
        self.id          = id
        self.$profile.id = profile
        self.path        = path
        self.exp         = exp
        self.kind        = kind
    }
}
