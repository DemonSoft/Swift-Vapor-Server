//
//  String+CurrencyFlag.swift
//  shelf
//
//  Created by Dmitriy Soloshenko on 09.05.2022.
//

import Foundation

extension String {
    private static let currencyPrefixes: [String: String] = [
    "EUR": "🇪🇺",
    "GEL": "🇬🇪",
    "USD": "🇺🇸",
    "UAH": "🇺🇦",
    "RUR": "🇷🇺"]
    
    
    var currencyFlagByCode: String {
        return Self.currencyPrefixes[self] ?? "🇺🇳"
    }
}
