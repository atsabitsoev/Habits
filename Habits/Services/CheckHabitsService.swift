//
//  CheckHabitsService.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 03.11.2020.
//

import Foundation

final class CheckHabitsService {
    
    private let dbService = DBService()
    
    var cleanedHabitIds: [String] {
        get {
            return (UserDefaults.standard.array(forKey: "cleanedHabitIds") as? [String]) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "cleanedHabitIds")
        }
    }
    var lastCheckDateString: String? {
        get {
            return UserDefaults.standard.string(forKey: "lastCheckHabitsDate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastCheckHabitsDate")
        }
    }
    
    
    func checkAllHabits() {
        let currentDate = Date()
        guard lastCheckDateString != currentDate.dateString() else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let currentDateString = dateFormatter.string(from: currentDate)
        guard let currentDayStart = dateFormatter.date(from: currentDateString) else { return }
                
        let habits = dbService.getAllHabits()
        for habit in habits {
            
            guard let lastDate = habit.lastDateDone else { continue }
            let lastDateString = dateFormatter.string(from: lastDate as Date)
            guard let lastDateDayStart = dateFormatter.date(from: lastDateString) else { continue }
            let daysFromLastDate = Int(currentDayStart.timeIntervalSince(lastDateDayStart) / 60 / 60 / 24)
            
            guard let weekDays = habit.weekdaysToRepeat else { continue }
            let lastDateWeekDay = (lastDate as Date).formattedWeekDay()
            
            guard let lastWeekDayIndex = weekDays.firstIndex(of: lastDateWeekDay) else { continue }
            let nextWeekDayIndex = lastWeekDayIndex < weekDays.count - 1 ? lastWeekDayIndex + 1 : 0
            let nextWeekDay = weekDays[nextWeekDayIndex]
            
            let daysBetweenLastAndNextWeekDays = nextWeekDay > lastDateWeekDay ? nextWeekDay - lastDateWeekDay : 7 - lastDateWeekDay + nextWeekDay
            
            if daysBetweenLastAndNextWeekDays < daysFromLastDate {
                let habitId = habit.objectID.uriRepresentation().relativeString
                cleanHabit(withId: habitId)
            }
        }
        lastCheckDateString = Date().dateString()
    }
    
    private func cleanHabit(withId id: String) {
        if dbService.setNewDayCountToHabit(
            withId: id,
            newDayCount: 0,
            todayDone: false
        ) {
            cleanedHabitIds.append(id)
        }
    }
    
}
