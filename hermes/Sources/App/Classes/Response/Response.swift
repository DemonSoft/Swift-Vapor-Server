//
//  File.swift
//  
//
//  Created by Dmitriy Soloshenko on 18.03.2023.
//

import Foundation
import Vapor

struct ResponseWrapper<T: Encodable>: Encodable {
    let data: T?
    let mistake: Mistake?
}

extension Response {
    static func success<T: Encodable>(_ data: T?) -> Response {
        
        let responseData = ResponseWrapper(data: data, mistake: nil)
        
        guard let data = try? JSONEncoder().encode(responseData) else {
            return Response(status: .ok, body: Body(data: Data()))
        }

        return Response(status: .ok, body: Body(data: data))
    }

    static func fail(_ message: String?, _ reasons: [String]? = nil) -> Response {
        
        let responseData = ResponseWrapper<String?>(data: nil, mistake: Mistake(message: message, reasons: reasons))
        
        guard let data = try? JSONEncoder().encode(responseData) else {
            return Self.fail(nil, ["Encoding error"])
        }

        return Response(status: .ok, body: Body(data: data))
    }

}
