//
//  Role.swift
//  
//
//  Created by Dmitriy Soloshenko on 04.04.2023.
//

import Foundation

enum Role: String, Codable, CaseIterable {
    case owner, admin, manager, user, lowest

    // Less index has higher priority
    func available(_ forRole: Role = .user) -> Bool {
        return self.index <= forRole.index
    }

    func greater(_ than: Role) -> Bool {
        self.index < than.index
    }
    
    private var index:  Int {
        let array:[Role] = Role.allCases
        return array.firstIndex(of: self) ?? array.count
    }

// NEVER DON'T USE THIS CODE.
// These comparisons call exception.
    
//    static func <(lhs: Role, rhs: Role) -> Bool {
//            return lhs.index < rhs.index
//    }
//
//    static func >(lhs: Role, rhs: Role) -> Bool {
//            return lhs.index > rhs.index
//    }
//
//    static func ==(lhs: Role, rhs: Role) -> Bool {
//            return lhs.index == rhs.index
//    }
}
