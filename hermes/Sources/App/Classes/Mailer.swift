//
//  Mailer.swift
//  
//
//  Created by Dmitriy Soloshenko on 26.03.2023.
//

import Vapor
import Smtp
import Fluent

class Mailer {
    
    static func sendConfirmEmail(_ req: Request, _ email: String, _ name: String, _ token: String) async throws {
        
        let body = "Hello \(name)\n\n" +
                   "Please tap on the link in your iPhone for confirmation of change your email.\n" +
                   self.deep(Constants.confirmChangeDL, token)

        let email = try! Email(from: EmailAddress(address: Constants.backEmail,
                                                     name: "\(Constants.serviceName): DO NOT RESPOND!"),
                               to: [EmailAddress(address: email, name: name)],
                          subject: "Changing email",
                          body: body)

        try await req.smtp.send(email)
    }

    static func sendRepairLink(_ req: Request, _ email: String, _ name: String, _ token: String) async throws {
        
        let body = "Hello \(name)\n\n" +
                   "Please tap on the link in your iPhone for confirmation of reset your password.\n" +
                   self.deep(Constants.resetPassDL, token)
        

        let email = try! Email(from: EmailAddress(address: Constants.backEmail,
                                                     name: "\(Constants.serviceName): DO NOT RESPOND!"),
                               to: [EmailAddress(address: email, name: name)],
                          subject: "Reset password",
                          body: body)

        try await req.smtp.send(email)
    }
    
    static func sendDeleteAccount(_ req: Request,
                                  _ email: String,
                                  _ name: String,
                                  _ token: String,
                                  _ datetime: Int64) async throws {
        
        let days = Constants.restoreAcc
        let body = "Hello \(name)\n\n" +
                   "You requested deleting your account.\n" +
                    "Operation executed successfully.\n" +
                    "You are available to restore your account duration \(days) days by this link:\n" +
                    self.deep(Constants.restoreAccDL, token) + "\n\n" +
                    "Thank you that you used our service.\n"

        let email = try! Email(from: EmailAddress(address: Constants.backEmail,
                                                     name: "\(Constants.serviceName): DO NOT RESPOND!"),
                               to: [EmailAddress(address: email, name: name)],
                          subject: "Your account was removed.",
                          body: body)

        try await req.smtp.send(email)
    }

    private static func deep(_ link: String, _ token: String) -> String {
        return "\(Constants.iosAppName)\(link)\(token)"
    }
}
