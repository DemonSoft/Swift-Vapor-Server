//
//  Push.swift
//  
//
//  Created by Dmitriy Soloshenko on 14.04.2023.
//

import Fluent
import Vapor


final class Push: Model, Content {
    
    static let schema = "pushes"

    @ID(key: .id)                     var id        : UUID?
    @Parent(key: "push_token_id")     var pushToken : PushToken
    @Field(key:  "title")             var title     : String
    @Field(key:  "subtitle")          var subtitle  : String?
    @Field(key:  "body")              var body      : String?
    @Field(key:  "payload")           var payload   : Data?
    @Field(key:  "read")              var read      : Bool
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, pushToken: PushToken.IDValue, title: String, subtitle: String?, body: String? = nil, read: Bool = false) {
        self.id               = id
        self.$pushToken.id    = pushToken
        self.title            = title
        self.subtitle         = subtitle
        self.body             = body
        self.read             = read
    }
    
    struct Public: Content, Encodable, Hashable {
        let id: UUID
        let title: String
        let subtitle: String
        let body: String
        let payload: Data
        let read: Bool
        let datetime: Int64
    }
}
