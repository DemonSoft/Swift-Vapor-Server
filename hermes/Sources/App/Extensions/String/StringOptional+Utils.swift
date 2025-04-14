//
//  StringOptional+Utils.swift
//  shelf
//
//  Created by Dmitriy Soloshenko on 09.05.2022.
//

import Foundation

extension Optional where Wrapped == String
{
    func verification(_ expression:String?, required:Bool = false) -> Bool
    {
        // when text is empty.
        if required && self == nil { return false } // text required
        guard let text = self else { return true }
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
