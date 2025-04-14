//
//  Confirmation.swift
//  
//
//  Created by Dmitriy Soloshenko on 31.03.2023.
//

import Fluent
import Vapor


final class Confirmation: Model, Content {
    enum Operation: String, Codable {
        case restore_pass, change_login, restore_acc
    }
    static let schema = "confirmations"

    @ID(key: .id)               var id        : UUID?
    @Parent(key: "user_id")     var user      : User
    @Field(key:  "exp")         var exp       : Int64 // Unix date and time of data expiration
    @Enum(key:   "operation")   var operation : Operation
    @Field(key:  "payload")     var payload   : String?
    @Timestamp(key: "created_at", on: .create)  var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)  var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, user: User.IDValue, exp: Int64 = 0, operation: Operation, payload: String? = nil) {
        self.id          = id
        self.$user.id    = user
        self.exp         = exp
        self.operation   = operation
        self.payload     = payload
    }
}
