//
//  String+expressions.swift
//  shelf
//
//  Created by Dmitriy Soloshenko on 25.05.2022.
//
import Foundation

extension String {
    static var emailExpression: String {
        return "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\\\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\\\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    }
    
    static var phoneShortExpression: String {
        return "^0\\d{9,10}"
    }
    
    static var phoneLongExpression: String {
        return "/^(?:(?:\\(?(?:00|\\+)([1-4]\\d\\d|[1-9]\\d+)\\)?)[\\-\\.\\ \\\\\\/]?)?((?:\\(?\\d{1,}\\)?[\\-\\.\\ \\\\\\/]?)+)(?:[\\-\\.\\ \\\\\\/]?(?:#|ext\\.?|extension|x)[\\-\\.\\ \\\\\\/]?(\\d+))?$/i"
    }

    func verification(_ expression:String?, required:Bool = false) -> Bool
    {
        let text = self
        guard required && text.count > 0 else { return false } // text required, but field is empty ("")
        guard text.count > 0 else { return true } // text no required, end text is empty ("")
        guard let expression else { return true } // no expression
        guard expression.filled else { return true } // no expression

        
//        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", expression)
//        let result = predicate.evaluate(with: self)
//        return result
        
        let _ = NSPredicate { evaluatedObject, _ in
            guard let string = evaluatedObject as? String else {
                return false
            }
            let regex = try! NSRegularExpression(pattern: expression, options: .caseInsensitive)
            let range = NSRange(location: 0, length: string.utf16.count)
            return regex.firstMatch(in: string, options: [], range: range) != nil
        }
        return false 
    }    
}
