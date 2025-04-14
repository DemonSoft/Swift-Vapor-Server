//
//  Date+Utils.swift
//  shelf
//
//  Created by Dmitriy Soloshenko on 05.05.2022.
//

import Foundation
/*
DON'T USE YYYY or YY. ONLY yyyy or yy
 */

extension Date {
    

    static var oneDay:Int64 {
        return Int64(Date.oneHour * 24)
    }

    static var oneHour:Int64 {
        return Int64(60 * 60 * 24)
    }

    static var epoch: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    static var now64:Int64 {
        return Int64(Date().timeIntervalSince1970)
    }

    static var now:Double {
        return Date().timeIntervalSince1970
    }

    static let dateMediumFormatter : DateFormatter = {
        let formatter       =  DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let dateShortFormatter : DateFormatter = {
        let formatter       =  DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    var humanMediumString : String {
        return Date.dateMediumFormatter.string(from: self)
    }

    var humanShortString : String {
        return Date.dateShortFormatter.string(from: self)
    }

    var humanLongString : String {
        return Date.longHumanDateFormatter.string(from: self)
    }

    var humanTimeString : String {
        return Date.timeFormatter.string(from: self)
    }

    var dateIso8610:String {
        return Date.dateOnlyFormatter.string(from: self)
    }

    var gsm:String {
        return Date.dateGSMFormatter.string(from: self)
    }

    var gsmTime:String {
        return Date.gsmTimeFormatter.string(from: self)
    }
    
    var localTime:String {
        return Date.timeShortFormatter.string(from: self)
    }
    
    var gsmDate:String {
        return Date.dateOnlyFormatter.string(from: self)
    }
    
    var expiredDate:String {
        return Date.dateExpiredFormatter.string(from: self)
    }
    
//    var gsmPosixTime:String {
//        return Date.gsmPosixShortTimeFormatter.string(from: self)
//    }
    
    var gsmPosixDate:String {
        return Date.dateOnlyPosixFormatter.string(from: self)
    }

    func addYears(years:Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = years
        
        return  Calendar.current.date(byAdding: dateComponent, to: self) ?? Date()
    }

    func addSeconds(_ sec:Int64) -> Date {
        var date = self
        date.addTimeInterval(Double(sec))
        return self
    }

    func addDays(days:Int) -> Date {
        let sec = TimeInterval(60 * 60 * 24 * days)
        var date = self
        date.addTimeInterval(Double(sec))
        return date
    }

    func addMonths(months:Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = months
        
        return  Calendar.current.date(byAdding: dateComponent, to: self) ?? Date()
    }

    static let dateOnlyFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dateOnlyPosixFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale     =  Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let gsmTimeFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let timeShortFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale     =  Locale(identifier: "en_US_POSIX")
        return formatter
    }()

//    static let gsmPosixTimeFormatter : DateFormatter = {
//        let formatter        =  DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        formatter.locale     =  Locale(identifier: "en_US_POSIX")
//        return formatter
//    }()

    static let gsmPosixShortTimeFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "hh:mm"
        formatter.locale     =  Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let dateOfMonthFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "E, d MMM"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dayOfMonthFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dayOfFullMonthFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "d LLLL"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let monthFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dateNumOnlyFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "d"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let yearOnlyFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let monthAndYearFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let monthAndYearCurrentLocateFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dateTimeFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dateTimePosixFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale     = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let dateTimeWeekFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "E, d MMM  HH:mm"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let datetimeWeekYearFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "E, d MMM  yyyy"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dateGSMFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()
    
    static let dateGSMPOSIXFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale     =  Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let dateGSM12HourFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let dateGSM12HourPOSIXFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm a"
        formatter.locale     =  Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let dateGSMWithSecFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale     = Calendar.current.locale
        return formatter
    }()
    
    static let dateGSMWithSecPosixFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale     =  Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.is12HoursFormat ? "hh:mm a" : "HH:mm"
        formatter.locale =  Calendar.current.locale
        return formatter
    }()

    static let dateExpiredFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "MM/yy"
        formatter.locale     =  Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static var is12HoursFormat : Bool {
            return DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.range(of: "a") != nil
    }
        
    static let shortHumanDateFormatter : DateFormatter = {
        let formatter       =  DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    static let mediumHumanDateFormatter : DateFormatter = {
        let formatter       =  DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let longHumanDateFormatter : DateFormatter = {
        let formatter       =  DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    public static var nowUTCTimestampString : String {
        let currentDateTime = Date()
        let seconds         = NSTimeZone.default.secondsFromGMT(for: currentDateTime)
        let timeZoneOffset  = Double(seconds)
        let utcDate         =  currentDateTime.addingTimeInterval(-timeZoneOffset)

        return self.dateTimePosixFormatter.string(from: utcDate)
    }

    public static var dateIntervalFormatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateTemplate = "dMMM"
        return formatter
    }()

    public static var dateIntervalWithYearFormatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateTemplate = "dMMM yyyy"
        return formatter
    }()

    public var diff:Double {
        return self.timeIntervalSinceNow
    }

    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    static var dateMin: Date {
        return Date(timeIntervalSince1970: 0)
    }
    static var dateMax: Date {
        return Date(timeIntervalSince1970: TimeInterval(Int.max-1))
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let start = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: start)!
        let end = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: end)!
        return Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
    }
    
    static let monthYYFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "MMM, yy"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()

    static let timeDateFormatter : DateFormatter = {
        let formatter        =  DateFormatter()
        formatter.dateFormat = "HH:mm • E, d MMM"
        formatter.locale     =  Calendar.current.locale
        return formatter
    }()
    
    var timeDateString : String {
        return Date.timeDateFormatter.string(from: self)
    }

}
