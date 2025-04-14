//
//  File.swift
//  
//
//  Created by Dmitriy Soloshenko on 02.04.2023.
//

import Fluent
import Vapor

class Maintenance {
    
    static func start(req: Request) {
        Task {
            do {
              try await Maintenance().launch(req)
            } catch(let e) {
                print(e.localizedDescription)
            }
        }
    }
    
    private func launch(_ req: Request) async throws {
        let currentDate = Int64(Date().timeIntervalSince1970)
//        print("CURRENT DATE \(currentDate)")
//        if let records = try? await UserToken.query(on: req.db).filter(\.$exp < currentDate).all() {
//            print("FOUND RECORDS \(records.count)")
//            for record in records {
//                print("TRY DELETE \(record.id?.uuidString ?? "")")
//                try? await record.delete(on: req.db)
//            }
//        }
        try await UserToken.query(on: req.db).filter(\.$exp < currentDate).delete(force: true)
        try await Confirmation.query(on: req.db).filter(\.$exp < currentDate).delete(force: true)
    }
}
