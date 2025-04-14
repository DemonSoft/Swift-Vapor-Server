//
//  UserToken.swift
//  
//
//  Created by Dmitriy Soloshenko on 22.04.2023.
//

import Fluent
import Vapor

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey  = \UserToken.$user
    static let exp      = \UserToken.$exp

    var isValid: Bool {
        self.exp > Int64(Date().timeIntervalSince1970)
    }
}
