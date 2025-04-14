//
//  Date+Calendar.swift
//  shelf
//
//  Created by Dmitriy Soloshenko on 05.05.2022.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: self.startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func dayNumberOfWeek() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday ?? Calendar.current.firstWeekday
    }

    func dayNumberOfMonth() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 1
    }
    
//    func calendarWeekIndexDay() -> Int {
//        let rawIndex = self.dayNumberOfWeek() - Calendar.current.firstWeekday
//        let amountDaysInWeek =  Calendar.current.shortWeekdaySymbols.count
//
//        return rawIndex >= 0 ? rawIndex : (amountDaysInWeek + rawIndex )
//    }

    func calendarWeekIndexDay() -> Int {
        return self.dayNumberOfWeek() < Calendar.current.firstWeekday ?
        Calendar.current.shortWeekdaySymbols.count - self.dayNumberOfWeek() :
        self.dayNumberOfWeek() - Calendar.current.firstWeekday
    }

    func numberOfWeekIndex() -> Int {
        let indexOfStartMonth = self.startOfMonth.calendarWeekIndexDay()
        let dayNumber = self.dayNumberOfMonth()
        let amountDaysInWeek =  Calendar.current.shortWeekdaySymbols.count

        let weekNumber = (indexOfStartMonth + (dayNumber - 1)) / amountDaysInWeek
        
        return weekNumber
    }
    
    func startNextMonth() -> Date {
        let endOfCurrentDateSec = self.endOfMonth.timeIntervalSince1970
        return Date(timeIntervalSince1970: endOfCurrentDateSec + 1)
    }
}
