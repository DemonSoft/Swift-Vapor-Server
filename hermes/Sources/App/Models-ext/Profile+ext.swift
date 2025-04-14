//
//  Profile.swift
//  
//
//  Created by Dmitriy Soloshenko on 22.04.2023.
//

import Fluent
import Vapor

extension Profile {
    var pub: Profile.Public {
        return Profile.Public(id: self.id,
                              first_name: self.first_name,
                              last_name: self.last_name,
                              nickname: self.nickname,
                              gender: self.gender,
                              age: self.age,
                              role: self.role,
                              avatar: self.avatar)
    }
        
    static func auth(_ req: Request) async throws {
        let user = try req.user()
        if let _ = user.id { return }
        throw Abort(.notFound)
    }
    
    var fullName: String {
        return "\(self.first_name) \(self.last_name)"
    }
}
