//
//  File.swift
//  
//
//  Created by Dmitriy Soloshenko on 13.03.2023.
//

import Foundation
import RoutingKit

struct Constants {
    static let lifetime        = 30 // Lifetime of auth token. 30 days
    static let lifetimePass    = Date.oneHour // Lifetime of change password. 1 hour
    static let restoreAcc      = 30 // Duration that user can restore account after delete. 30 days
    static let xTokenHeader    = "X-Token"
    static let xTokenValue     = "<UUID>"
    static let bcryptSalt      = "<ANY LONG STRING>"
    static let xBearer         = "Bearer"
    static let avatarStorage   = "storage/avatars/"
    static let imageStorage    = "storage/images/"
    static let avatarExtension = ".jpg"
    static let imageExtension  = ".jpg"
    static let minimalPassword = 8
    static let iosAppName      = "hermesApp"

    // MARK: - NETWORK
    static let restRootGroup   = PathComponent("api")
    static let restVersion     = PathComponent("v.1")
    
    static let backEmail       = "<YOUR email>"
    static let serviceName     = "Hermes Core Server"
    
    
    // MARK: - APN
    static let apnCertPath       = "AuthKey.p8"
    static let keyIdentifier     = "<Key identifier>"
    static let teamIdentifier    = "<Team identifier>"
    static let apnTopic          = "com.<YOUR HOST>.<YOUR APP NAME>"

    
    // MARK: - Deep links
    static let restoreAccDL       = "://restore-acc/"
    static let resetPassDL        = "://reset-password/"
    static let confirmChangeDL    = "://confirm-change/"
    
    
    // MARK: - STRIPE
    static let stipePublicKey =
    "pk_test_<STRIPE PUBLIC KEY>"
    static let stipePrivateKey =
    "sk_test_<STRIPE PRIVATE KEY>"
    
}
