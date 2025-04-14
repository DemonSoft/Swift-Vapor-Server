//
//  String+Utils.swift
//  shelf
//
//  Created by Dmitriy Soloshenko on 09.05.2022.
//

import Foundation

extension String {
    
    var trim: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var filled : Bool {
        self.trim.count > 0
    }
    
    func replace(targets:[String], string: String) -> String {
        var result = self
        for target in targets {
            result = result.replacingOccurrences(of: target, with: string)
        }
        
        return result
    }
    
    var isoShortDateLikeShortHumanDate : String {
        guard let date = Date.dateOnlyFormatter.date(from: self) else { return ""}
        return Date.shortHumanDateFormatter.string(from: date)
    }

    var isoShortDateLikeMediumtHumanDate : String {
        guard let date = Date.dateOnlyFormatter.date(from: self) else { return ""}
        return Date.mediumHumanDateFormatter.string(from: date)
    }
    
    var isoDate : Date? {
        return Date.dateOnlyFormatter.date(from: self)
    }

    var isoDateUnpacked : Date {
        return Date.dateOnlyFormatter.date(from: self) ?? Date(timeIntervalSince1970: 0)
    }

    var datetime : Date {
        let is12H = self.contains("AM") || self.contains("PM")
        let rawDate = is12H ? Date.dateGSM12HourFormatter.date(from: self) : Date.dateGSMPOSIXFormatter.date(from: self)
        let date = rawDate ?? Date()
        return date
    }
    
    var opt : String? {
        let value:String? = self
        return value
    }
    
    // MARK: - Currency and flags
    var flagByCountry: String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in self.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }

        return String(usv)
    }
    
    var currencyName: String {
        return Locale.current.localizedString(forCurrencyCode: self) ?? ""
    }

    var country: String {
        return Locale.current.localizedString(forRegionCode: self) ?? ""
    }
    
    static func flagByCountry(code: String) -> String {
        return code.flagByCountry
    }

    static func country(code: String) -> String {
        return code.country
    }
    
    var flagByCurrency: String {
        if self == "XOF" { return ""}
        
        let exceptContryCodes = ["XAF", "XCD", "XPF"]
        var code = ""
        if exceptContryCodes.contains(self) {
            code = String(self.suffix(2))
        } else {
            code = String(self.prefix(2))
        }
        return code.flagByCountry
     }
    
    var symbolByCurrency: String {
        let locale = NSLocale(localeIdentifier: self)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: self) ?? ""
    }
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
    var digitString : String {
        let array = self.digits
        return array.reduce("") { $0 + "\($1)" }
    }
    
    var compactUUID:  String {
        return self.lowercased().replacingOccurrences(of: "-", with: "")
    }
    
    static var states: [String] {
        return [ "AK - Alaska",
                 "AL - Alabama",
                 "AR - Arkansas",
                 "AS - American Samoa",
                 "AZ - Arizona",
                 "CA - California",
                 "CO - Colorado",
                 "CT - Connecticut",
                 "DC - District of Columbia",
                 "DE - Delaware",
                 "FL - Florida",
                 "GA - Georgia",
                 "GU - Guam",
                 "HI - Hawaii",
                 "IA - Iowa",
                 "ID - Idaho",
                 "IL - Illinois",
                 "IN - Indiana",
                 "KS - Kansas",
                 "KY - Kentucky",
                 "LA - Louisiana",
                 "MA - Massachusetts",
                 "MD - Maryland",
                 "ME - Maine",
                 "MI - Michigan",
                 "MN - Minnesota",
                 "MO - Missouri",
                 "MS - Mississippi",
                 "MT - Montana",
                 "NC - North Carolina",
                 "ND - North Dakota",
                 "NE - Nebraska",
                 "NH - New Hampshire",
                 "NJ - New Jersey",
                 "NM - New Mexico",
                 "NV - Nevada",
                 "NY - New York",
                 "OH - Ohio",
                 "OK - Oklahoma",
                 "OR - Oregon",
                 "PA - Pennsylvania",
                 "PR - Puerto Rico",
                 "RI - Rhode Island",
                 "SC - South Carolina",
                 "SD - South Dakota",
                 "TN - Tennessee",
                 "TX - Texas",
                 "UT - Utah",
                 "VA - Virginia",
                 "VI - Virgin Islands",
                 "VT - Vermont",
                 "WA - Washington",
                 "WI - Wisconsin",
                 "WV - West Virginia",
                 "WY - Wyoming"]
    }    
}
