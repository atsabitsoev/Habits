//
//  HabitListController.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 16.10.2020.
//

import UIKit

final class HabitListController: UIViewController, HabitListControlling {
    
    enum State {
        case allHabits
        case todayHabits
    }
    
    
    private var habitListView: HabitListViewing!
    private let dbService = DBService()
    
    private var state: State = .todayHabits {
        didSet {
            configureNavigationBar()
            fetchHabits()
        }
    }
    private var habits: [Habit] = []
    
    
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
        _ = dbService.setNewDayCountToHabit(withId: entityId, newDayCount: newDayCount, todayDone: todayDone)
    }
    
    func editHabit(withId id: String) {
        guard let habit = habits.first(where: {$0.objectID.uriRepresentation().relativeString == id}) else { return }
        let editor = HabitEditorController(habit: habit)
        navigationController?.show(editor, sender: nil)
    }
    
    func deleteHabit(withId id: String) {
        guard let index = habits.firstIndex(where: {$0.objectID.uriRepresentation().relativeString == id}) else { return }
        if dbService.deleteHabit(withId: id) {
            habits.remove(at: index)
        }
    }
    
    
    private func configureNavigationBar() {
        title = state == .todayHabits ? "Сегодня" : "Все привычки"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: state == .todayHabits ? "Все привычки" : "Сегодня",
            style: .plain,
            target: self,
            action: #selector(changeStateButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchHabits() {
        dbService.getAllHabits { (habits, errorString) in
            guard let habits = habits else {
                print(errorString ?? "Неизвестная ошибка")
                return
            }
            self.habits = state == .todayHabits ? habits.filter({ $0.shouldBeShownNow() }) : habits
            let habitItems = self.habits.compactMap { (habit) -> HabitItem? in
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
    
    @objc private func changeStateButtonTapped() {
        state = state == .todayHabits ? .allHabits : .todayHabits
    }
    
}
