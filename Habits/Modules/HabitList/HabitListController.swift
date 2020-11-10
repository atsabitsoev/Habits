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
    private let notificationsService = LocalNotificationsService()
    private let checkHabitsService = CheckHabitsService()
    private let habitsProgressService = HabitProgressService()
    
    private var state: State = .todayHabits {
        didSet {
            habitListView.setState(state)
            configureNavigationBar()
            fetchHabits()
        }
    }
    private var habits: [Habit] = []
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        habitListView = HabitListView(controller: self)
        view = habitListView
        habitListView.configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Vibration.heavy.vibrate()
        configureNavigationBar()
        habitListView.setState(state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHabits()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCleanedHabitsIfNeeded()
    }
    
    
    // MARK: - Opened funcs
    func dayCountChanged(entityId: String, newDayCount: Int, todayDone: Bool) {
        _ = dbService.setNewDayCountToHabit(withId: entityId, newDayCount: newDayCount, todayDone: todayDone)
        if habitsProgressService.isStartOfLevel(daysCompleted: newDayCount) && todayDone {
            showCongratulationAlert(finishedLevel: habitsProgressService.getProgress(daysCompleted: newDayCount).0 + 1)
        }
    }
    
    func editHabitAction(withId id: String) {
        guard let habit = habits.first(where: {$0.objectID.uriRepresentation().relativeString == id}) else { return }
        let editor = HabitEditorController(habit: habit)
        navigationController?.show(editor, sender: nil)
    }
    
    func deleteHabitAction(withId id: String) {
        alertDelete(habitId: id)
    }
    
    // MARK: - Configure
    private func configureNavigationBar() {
        title = state == .todayHabits ? "Сегодня" : "Все привычки"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: state == .todayHabits ? "Все привычки" : "Сегодня",
            style: .plain,
            target: self,
            action: #selector(changeStateButtonTapped)
        )
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Habits Functions
    private func fetchHabits() {
        let habits = dbService.getAllHabits()
        self.habits = state == .todayHabits ? habits.filter({ $0.shouldBeShownNow() }) : habits
        let habitItems = self.habits.compactMap { (habit) -> HabitItem? in
            let habitItem = habitToItem(habit)
            return habitItem
        }
        habitListView.setItems(habitItems)
    }
    
    private func deleteHabit(withId id: String) {
        guard let index = habits.firstIndex(where: {$0.objectID.uriRepresentation().relativeString == id}) else { return }
        let currentHabit = habits[index]
        if let weekDays = currentHabit.weekdaysToRepeat,
           let _ = currentHabit.notificationTime {
            notificationsService.removeNotification(
                id: currentHabit.objectID.uriRepresentation().relativeString,
                weekDays: weekDays
            )
        }
        if dbService.deleteHabit(withId: id) {
            habits.remove(at: index)
            habitListView.deleteHabit(atRow: index)
        }
    }
    
    private func showCleanedHabitsIfNeeded() {
        let cleanedHabitIds = checkHabitsService.cleanedHabitIds
        if cleanedHabitIds.count > 0 {
            let cleanedHabits = habits.filter({ cleanedHabitIds.contains($0.objectID.uriRepresentation().relativeString) })
            var alertMessage = ""
            let cleanedHabitsCount = habits.count
            guard cleanedHabitsCount > 0 else { return }
            if cleanedHabits.count == 1 {
                guard let name = habits.first?.name else { return }
                alertMessage = "Привычка \"\(name)\" была пропущена, ваш прогресс обнулен :("
            } else {
                let cleanedHabitsNames = cleanedHabits.compactMap({ $0.name }).map({ "\"\($0)\"" })
                let cleanedHabitsNamesString = cleanedHabitsNames.joined(separator: ", ")
                alertMessage = "Привычки: \(cleanedHabitsNamesString) были пропущены, ваш прогресс по ним обнулен :("
            }
            showOkAlert(message: alertMessage)
        }
    }
    
    // MARK: - Habit to Item
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
        if let lastDateDone = habit.lastDateDone as Date? {
            let lastDateWasNotToday = lastDateDone.distance(to: now) - secondsFromTodayStart <= 0
            todayDone = lastDateWasNotToday
        } else {
            todayDone = false
        }
        let shouldShowCheckbox = state == .todayHabits
        
        
        let habitItem = HabitItem(
            id: id,
            name: name,
            descriptionString: descriptionString,
            image: image,
            dayCount: dayCount.intValue,
            isShownFullDescription: false,
            todayDone: todayDone,
            shouldShowCheckbox: shouldShowCheckbox
        )
        return habitItem
    }
    
    private func showHabitEditor() {
        navigationController?.show(HabitEditorController(), sender: nil)
    }
    
    // MARK: Alerts
    private func alertDelete(habitId id: String) {
        let alert = UIAlertController(title: nil, message: "Вы уверены?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] (_) in
            self?.deleteHabit(withId: id)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func showOkAlert(message: String) {
        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.textAlignment = .center
        let alert = AlertContainerViewController(mainView: messageLabel, title: "Прогресс потерян")
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        navigationController?.present(alert, animated: true, completion: { [weak self] in
            self?.checkHabitsService.cleanedHabitIds = []
        })
    }
    
    private func showCongratulationAlert(finishedLevel: Int) {
        let congratulationView = CongratulationView(congratulation: "Вы успешно завершили \(finishedLevel) уровень")
        let alert = AlertContainerViewController(mainView: congratulationView, title: "Поздравляем!")
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        showHabitEditor()
    }
    
    @objc private func changeStateButtonTapped() {
        state = state == .todayHabits ? .allHabits : .todayHabits
    }
    
    
}
