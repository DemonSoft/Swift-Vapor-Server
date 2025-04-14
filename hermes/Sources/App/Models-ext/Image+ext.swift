//
//  Image.swift
//  
//
//  Created by Dmitriy Soloshenko on 22.04.2023.
//

import Fluent
import Vapor

extension Image {
    static func avatarPath(_ req: Request, _ id: UUID) -> String {
        let storage = Environment.get("STORAGE_AVATARS") ?? Constants.avatarStorage
        return req.application.directory.workingDirectory
        + "\(storage)/\(id)\(Constants.avatarExtension)"
    }

    static func imagePath(_ req: Request, _ id: UUID) -> String {
        let storage = Environment.get("STORAGE_IMAGES") ?? Constants.imageStorage
        return req.application.directory.workingDirectory
        + "\(storage)/\(id)\(Constants.imageExtension)"
    }
}
