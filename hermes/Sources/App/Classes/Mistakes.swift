//
//  Mistakes.swift
//  
//
//  Created by Dmitriy Soloshenko on 25.03.2023.
//

import Foundation

struct Mistakes {
    static let unauthorized        = "Unauthorized"
    static let invalidEmail        = "This email is not valid"
    static let invalidPass         = "Password must contain \(Constants.minimalPassword) and more characters"
    static let idWrongFormat       = "ID has wrong format"
    static let idNotFound          = "Source with ID not found"
    static let profileNotFound     = "Profile not found"
    static let iAmTeapot           = "I’m a teapot"
    static let productCannotDelete = "Product not found and cannot delete"
    static let imageIsWrong        = "Image is wrong"
    static let userNotFound        = "User not found"
    static let cannotRepair        = "Password cannot repair"
    static let cannotChange        = "Email cannot change"
    static let usersNotFound       = "Users not found"
    static let paramsAreWrong      = "Parameters have wrong format"
    static let pushesRegistered    = "Push token already registered"
    static let pushesCannotEqual   = "Title and subtitle cannot be equal"

    static let accountCannotDelete = "Account cannot be removed"
    static let accountCantRestore  = "Account cannot be restored"

    
}
