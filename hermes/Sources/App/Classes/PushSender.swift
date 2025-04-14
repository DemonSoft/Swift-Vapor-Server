//
//  PushSender.swift
//  
//
//  Created by Dmitriy Soloshenko on 14.04.2023.
//

import Fluent
import Vapor
import APNS

class PushSender {
    func send(req: Request, tokens:[PushToken], title: String, subtitle: String?, body: String?) async throws {
        for token in tokens {
            let unread = try await token.countUnread(req)
            let alert  = APNSwiftAlert(title: title, subtitle: subtitle, body: body)
            let aps    = APNSwiftPayload(alert: alert, badge: unread + 1, sound: .normal("cow.wav"))
            let _      = req.apns.send(aps, to: token.token)
            
            guard let id = token.id else { throw Abort(.internalServerError) }
            let push = Push(pushToken: id, title: title, subtitle: subtitle, body: body)
            try await push.save(on: req.db)
        }
    }
}

