//
//  CalendarMonth.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import Foundation

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isInCurrentMonth: Bool
    let hasLog: Bool?
}

struct CalendarMonth {
    let monthDate: Date
    
    func generateWeeks() -> [[CalendarDay]] {
        // gets user's calendar system, like Gregorian
        let calendar = Calendar.current
        
        // takes year and month from target date e.g. components.year = 2025, components.month = 7
        var components = calendar.dateComponents([.year, .month], from: monthDate)
        
        // builds a new Date from the components. no day provided defaults to 1st at midnight
        let firstOfMonth = calendar.date(from: components)!
        
        // returns a Range<Int> for number of days in month for provided Date e.g. 1..<32
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth)!
        
        // this just straight up returns an int for the weekday the Date is on. e.g. if Sunday, weekday = 1, Saturday, weekday = 7
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        
        var days: [CalendarDay] = []
        
        // add previous month's extra days from week start
        if weekday != 1 {
            let daysNeeded = weekday - 1
            
            let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: firstOfMonth)
            let numOfDaysInPrevMonth = range.count
            var prevComponents = calendar.dateComponents([.year, .month], from: previousMonthDate!)
            
            for i in(numOfDaysInPrevMonth - daysNeeded)...numOfDaysInPrevMonth - 1 {
                prevComponents.day = i
                let date = calendar.date(from: prevComponents)!
                days.append(CalendarDay(date: date, isInCurrentMonth: false, hasLog: nil))
            }
        }
        
        // add each CalendarDay from 1 to total days
        for day in 1...range.count {
            components.day = day
            let date = calendar.date(from: components)!
            days.append(CalendarDay(date: date, isInCurrentMonth: true, hasLog: nil))
        }
        
        // add next month's beginning days until week end
        let totalDaysSoFar = days.count
        let remaining = totalDaysSoFar % 7
        let daysNeeded = remaining == 0 ? 0 : 7 - remaining
        
        if daysNeeded > 0 {
            var nextComponents = calendar.dateComponents([.year, .month], from: firstOfMonth)
            nextComponents.month! += 1
            
            for i in 1...daysNeeded {
                nextComponents.day = i
                let date = calendar.date(from: nextComponents)!
                days.append(CalendarDay(date: date, isInCurrentMonth: false, hasLog: nil))
            }
        }
        
        // split into 7 days
        let weeks = stride(from: 0, to: days.count, by: 7).map {
            Array(days[$0..<min($0+7, days.count)])
        }
        
        return weeks
    }
}
