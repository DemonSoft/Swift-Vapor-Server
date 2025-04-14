//
//  Storage.swift
//  
//
//  Created by Dmitriy Soloshenko on 20.04.2023.
//

import Foundation
import Vapor

class Storage: LifecycleHandler {
    // Called before application boots.
    func willBoot(_ app: Application) throws {
        
        do {
            try createIfNotExist(app, Environment.get("STORAGE_AVATARS") ?? Constants.avatarStorage)
            try createIfNotExist(app, Environment.get("STORAGE_IMAGES") ?? Constants.imageStorage)
        }
        catch let e {
            print("FILE SYSTEM: \(e.localizedDescription)")
        }
    }
    
    private func createIfNotExist(_ app: Application, _ path: String) throws {
        let fullPath = app.directory.workingDirectory + path
        try FileManager.default.createDirectory(atPath: fullPath, withIntermediateDirectories: true)
    }
}
