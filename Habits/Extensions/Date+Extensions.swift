//
//  Date+Extensions.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 29.10.2020.
//

import Foundation

extension Date {
    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: self)
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
    
    func weekDay() -> Int {
        let calendar = Calendar.current
        let currentWeekDay = calendar.component(.weekday, from: self)
        return currentWeekDay
    }
    
    func formattedWeekDay() -> Int {
        let currentWeekDay = self.weekDay()
        var formattedWeekDay = 0
        if currentWeekDay < 2 {
            formattedWeekDay = 6
        } else {
            formattedWeekDay = currentWeekDay - 2
        }
        return formattedWeekDay
    }
}
