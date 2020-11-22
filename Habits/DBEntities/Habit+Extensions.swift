//
//  Habit+Extensions.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 02.11.2020.
//

import Foundation

extension Habit {
    func shouldBeShownNow() -> Bool {
        let formattedWeekDay = Date().formattedWeekDay()
        return weekdaysToRepeat?.contains(formattedWeekDay) ?? false
    }
}
