//
//  HabitListController.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 16.10.2020.
//

import UIKit

final class HabitListController: UIViewController, HabitListControlling {
    
    private var habitListView: HabitListViewing!
    private let dbService = DBService()
    
    
    override func loadView() {
        super.loadView()
        habitListView = HabitListView(controller: self)
        view = habitListView
        habitListView.configureView()
        fetchHabits()
    }
    
    
    func dayCountChanged(entityId: String, newDayCount: Int, todayDone: Bool) {
        dbService.setNewDayCountToHabit(withId: entityId, newDayCount: newDayCount, todayDone: todayDone)
    }
    
    
    private func fetchHabits() {
        dbService.getAllHabits { (habits, errorString) in
            guard let habits = habits else {
                print(errorString ?? "Неизвестная ошибка")
                return
            }
            let habitItems = habits.compactMap { (habit) -> HabitItem? in
                let habitItem = habitToItem(habit)
                return habitItem
            }
            habitListView.setItems(habitItems)
        }
    }
    
    private func habitToItem(_ habit: Habit) -> HabitItem? {
        let id = habit.objectID.uriRepresentation().relativeString
        guard let name = habit.name,
              let description = habit.descriptionString,
              let imageName = habit.imageName,
              let image = HabitImage(rawValue: imageName),
              let dayCount = habit.dayCount else { return nil }
        
        var todayDone = false
        let calendar = Calendar.current
        let now = Date()
        let nowComponents = calendar.dateComponents([.hour, .minute, .second], from: now)
        let hoursToSeconds = (nowComponents.hour ?? 0) * 3600
        let minutesToSeconds = (nowComponents.minute ?? 0) * 60
        let seconds = (nowComponents.second ?? 0)
        let secondsFromTodayStart: Double = Double(hoursToSeconds + minutesToSeconds + seconds)
        if let lastDateDone = habit.lastDateDone {
            let lastDateWasNotToday = lastDateDone.distance(to: now) - secondsFromTodayStart <= 0
            todayDone = lastDateWasNotToday
        } else {
            todayDone = false
        }
        
        
        let habitItem = HabitItem(
            id: id,
            name: name,
            description: description,
            image: image,
            dayCount: dayCount.intValue,
            isShownFullDescription: false,
            todayDone: todayDone
        )
        return habitItem
    }
    
}
