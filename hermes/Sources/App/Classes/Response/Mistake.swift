//
//  File.swift
//  
//
//  Created by Dmitriy Soloshenko on 18.03.2023.
//

import Foundation
import Vapor

struct Mistake: Encodable {
    let message: String?
    let reasons: [String]?
}
