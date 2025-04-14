//
//  File.swift
//  
//
//  Created by Dmitriy Soloshenko on 25.03.2023.
//

import Fluent
import Vapor

struct ImageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let images = routes.root.grouped("images")
        
        let protected = images.grouped(UserToken.authenticator())
        protected.get(use: getImage)
        protected.post(use: upload)
        
        protected.group("list") { list in
            list.get(":id", use: getImage)
            list.post(use: imageList)
        }
        
        protected.group("avatar") { avatar in
            avatar.get(":id", use: getAvatar)
        }
    }
    
    // Gettings avatar
    func getAvatar(req: Request) async throws -> Response {
        
        guard let id = req.parameters.get("id"),
              let imageId = UUID(uuidString: id) else {
            return Response.fail(Mistakes.idWrongFormat)
        }
        guard let image = try await Image.find(imageId, on: req.db) else {
            return Response.fail(Mistakes.idNotFound)
        }

        let profileId = image.$profile.id
        
        let imagePath = Image.avatarPath(req, profileId)
        let fileURL   = URL(fileURLWithPath: imagePath)
        let data      = try Data(contentsOf: fileURL)
        let response  = Response(status: .ok,
                                 headers: HTTPHeaders([("Content-Type", "image/png")]),
                                 body: Response.Body(data: data))
        
        return response
    }
    
    // MARK -- IMAGES
    func upload(req: Request) async throws -> Response {
        struct DTO: Content {
            var image: Data
        }

        let profile  = try await req.me()
        guard let id = profile.id else { return Response.fail(Mistakes.profileNotFound) }

        guard let dto = try? req.content.decode(DTO.self) else {
            return Response.fail(Mistakes.imageIsWrong)
        }
        
        let byteBuffer = ByteBuffer(data: dto.image)
        let imageId    = UUID()
        let imagePath  = Image.imagePath(req, imageId)
        let image      = Image(id:imageId, profile: id, path:imagePath, exp: Int64.max)
        
        try await req.fileio.writeFile(byteBuffer, at: imagePath)
        
        try await image.save(on: req.db)
        return Response.success(imageId)
    }
    
    // Getting's image
    func getImage(req: Request) async throws -> Response {
        
        guard let id = req.parameters.get("id"),
              let imageId = UUID(uuidString: id) else {
            return Response.fail(Mistakes.idWrongFormat)
        }
        guard let image = try await Image.find(imageId, on: req.db) else {
            return Response.fail(Mistakes.idNotFound)
        }

        let fileURL   = URL(fileURLWithPath: image.path)
        let data      = try Data(contentsOf: fileURL)
        let response  = Response(status: .ok,
                                 headers: HTTPHeaders([("Content-Type", "image/png")]),
                                 body: Response.Body(data: data))
        
        return response
    }

    // Getting's images
    func imageList(req: Request) async throws -> Response {

        struct DTO: Content {
            let startDate: Int
            let maxCount: Int
        }

        guard let dto = try? req.content.decode(DTO.self) else {
            throw Abort(.badRequest)
        }
        
        let dDate = Date(timeIntervalSince1970: Double(dto.startDate))

        let images = try await Image.query(on: req.db).group(.and, { group in
            group
                .filter (\.$createdAt > dDate)
                .filter(\.$kind == Image.Kind.regular)
        })
            .all()
            .prefix(dto.maxCount)
            .compactMap { $0.id }

        return Response.success(Array(images))
    }
}
