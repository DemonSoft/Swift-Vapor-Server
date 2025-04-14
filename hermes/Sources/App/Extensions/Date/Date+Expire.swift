//
//  Date+Remainder.swift
//  shelf
//
//  Created by Dmitriy Soloshenko on 05.05.2022.
//

import Foundation

extension Date {
    
    func expireIn(unixInt:Int) -> String {
    
        let remaindSec = Int(Double(unixInt) - self.timeIntervalSince1970)
        guard remaindSec > 0 else { return "" }
        
        let oneMinite = 60
        let oneHour = oneMinite * 60
        let oneDay = oneHour * 24
        
        let secs = remaindSec % oneMinite
        let mins = (remaindSec % oneHour) / oneMinite
        let hours = (remaindSec % oneDay) / oneHour
        let days = remaindSec / oneDay

        var message = ""
        
        if remaindSec < oneMinite { message = "Less then one minute expires" } else
        if remaindSec < oneHour { message = "expires in \(mins) min. \(secs) sec." } else
        if remaindSec < oneDay { message = "expires in \(hours) hours \(mins) minutes" } else
        { message = "expires in \(days) days \(hours) hours" }

       return message

    }

    func remaindTo(unixInt:Int) -> String {
    
        let remaindSec = Int(Double(unixInt) - self.timeIntervalSince1970)
        guard remaindSec > 0 else { return "" }
        
        let oneMinite = 60
        let oneHour = oneMinite * 60
        let oneDay = oneHour * 24
        
        let secs = remaindSec % oneMinite
        let mins = (remaindSec % oneHour) / oneMinite
        let hours = (remaindSec % oneDay) / oneHour
        let days = remaindSec / oneDay

        var message = ""
        
        if remaindSec < oneMinite { message = "Less then one minute remaining" } else
        if remaindSec < oneHour { message = "\(mins) min. \(secs) sec. remaining" } else
        if remaindSec < oneDay { message = "\(hours) hours \(mins) minutes remaining" } else
        { message = "\(days) days \(hours) hours remaining" }

        return message

    }
    
    static func ago(unixInt:Int64) -> String {
        
        let duration        = Int64(Date().timeIntervalSince1970) - unixInt
        
        let oneMinite:Int64 = 60
        let oneHour:Int64   = oneMinite * 60
        let oneDay:Int64    = oneHour * 24
        
        let secs            = duration % oneMinite
        let mins            = (duration % oneHour) / oneMinite
        let hours           = (duration % oneDay) / oneHour
        let days            = duration / oneDay

        var message         = ""
        
        if duration < oneMinite { message = "\(secs) sec. ago" } else
        if duration < oneHour { message = "\(mins) min. ago" } else
        if duration < oneDay { message = "\(hours) hours ago" } else
        { message = "\(days) days ago" }

        return message
    }
    
    static func salesTo(unixInt:Int64) -> String {

        let duration        = unixInt
        
        let oneMinite:Int64 = 60
        let oneHour:Int64   = oneMinite * 60
        let oneDay:Int64    = oneHour * 24
        
        let secs            = duration % oneMinite
        let mins            = (duration % oneHour) / oneMinite
        let hours           = (duration % oneDay) / oneHour
        let days            = duration / oneDay

        var message         = ""
        if duration < oneDay { message = "\(hours):\(mins):\(secs)" } else
        { message = "\(days)d \(hours):\(mins):\(secs)" }

        return message
    }
    
}
