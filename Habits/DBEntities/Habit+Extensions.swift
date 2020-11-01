//
//  Habit+Extensions.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 02.11.2020.
//

import Foundation

extension Habit {
    func shouldBeShownNow() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentWeekDay = calendar.component(.weekday, from: now)
        var formattedWeekDay = 0
        if currentWeekDay < 2 {
            formattedWeekDay = 6
        } else {
            formattedWeekDay = currentWeekDay - 2
        }
        return weekdaysToRepeat?.contains(formattedWeekDay) ?? false
    }
}
