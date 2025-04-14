//
//  GoogleJWTClaims.swift
//  
//
//  Created by Dmitriy Soloshenko on 08.04.2023.
//

import Foundation
import JWT

// MARK: - GoogleJWTClaims
struct GoogleJWTClaims: JWTPayload, Codable {
    
    let iss: String
    let azp, aud, sub, email: String
    let emailVerified: Bool
    let atHash, nonce, name: String
    let picture: String
    let givenName, familyName, locale: String
    let iat, exp: Int

    enum CodingKeys: String, CodingKey {
        case iss, azp, aud, sub, email
        case emailVerified = "email_verified"
        case atHash = "at_hash"
        case nonce, name, picture
        case givenName = "given_name"
        case familyName = "family_name"
        case locale, iat, exp
    }
    
    func verify(using signer: JWTKit.JWTSigner) throws {
    }
}

