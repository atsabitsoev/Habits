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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHabits()
    }
    
    
    func dayCountChanged(entityId: String, newDayCount: Int, todayDone: Bool) {
        dbService.setNewDayCountToHabit(withId: entityId, newDayCount: newDayCount, todayDone: todayDone)
    }
    
    
    private func configureNavigationBar() {
        title = "Привычки"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
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
            habitListView.setItems(habitItems.reversed())
        }
    }
    
    private func habitToItem(_ habit: Habit) -> HabitItem? {
        let id = habit.objectID.uriRepresentation().relativeString
        guard let name = habit.name,
              let imageName = habit.imageName,
              let image = HabitImage(rawValue: imageName),
              let dayCount = habit.dayCount else { return nil }
        let descriptionString = habit.descriptionString
        
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
            descriptionString: descriptionString,
            image: image,
            dayCount: dayCount.intValue,
            isShownFullDescription: false,
            todayDone: todayDone
        )
        return habitItem
    }
    
    private func showHabitEditor() {
        navigationController?.show(HabitEditorController(), sender: nil)
    }
    
    
    @objc private func addButtonTapped() {
        showHabitEditor()
    }
    
}
