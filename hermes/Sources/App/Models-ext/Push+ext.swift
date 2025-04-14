//
//  Push.swift
//  
//
//  Created by Dmitriy Soloshenko on 22.04.2023.
//

import Fluent
import Vapor

extension Push {
    var pub: Public {
        return Public(id: self.id ?? UUID(),
                      title: self.title,
                      subtitle: self.subtitle ?? "",
                      body: self.body ?? "",
                      payload: self.payload ?? Data(),
                      read: self.read,
                      datetime: Int64((self.createdAt ?? Date.epoch).timeIntervalSince1970))
    }
}

