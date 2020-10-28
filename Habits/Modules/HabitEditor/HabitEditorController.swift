//
//  HabitEditorController.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 19.10.2020.
//

import UIKit

final class HabitEditorController: UIViewController, HabitEditorControlling {
    
    private enum State {
        case create
        case edit
    }
    
    
    private var habitEditorView: HabitEditorViewing!
    private let dbService = DBService()
    
    private var doneButton: UIBarButtonItem!
    
    private let habit: Habit?
    private let state: State
    private var creatingHabit = CreatingHabit()
    
    
    init(habit: Habit? = nil) {
        self.habit = habit
        state = habit == nil ? .create : .edit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        habitEditorView = HabitEditorView(controller: self)
        view = habitEditorView
        habitEditorView.configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        checkDoneButton()
        setViewValues()
    }
    
    
    func setName(_ name: String) {
        creatingHabit.name = name
        checkDoneButton()
    }
    
    func setDescription(_ description: String) {
        creatingHabit.descriptionString = description
    }
    
    func setImageName(_ imageName: String) {
        guard let image = HabitImage(rawValue: imageName) else { return }
        creatingHabit.image = image
    }
    
    func addWeekDayToRepeat(_ weekDay: Int) {
        if !creatingHabit.weekdaysToRepeat.contains(weekDay) {
            creatingHabit.weekdaysToRepeat.append(weekDay)
        }
        creatingHabit.weekdaysToRepeat.sort(by: {$0 < $1})
    }
    
    func deleteWeekDayToRepeat(_ weekDay: Int) {
        if creatingHabit.weekdaysToRepeat.contains(weekDay) {
            creatingHabit.weekdaysToRepeat.remove(at: creatingHabit.weekdaysToRepeat.firstIndex(of: weekDay)!)
        }
        creatingHabit.weekdaysToRepeat.sort(by: {$0 < $1})
    }
    
    func setNotificationTime(_ notifTime: String?) {
        creatingHabit.notificationTime = notifTime
    }
    
    
    private func checkDoneButton() {
        doneButton.isEnabled = !(creatingHabit.name?.isEmpty ?? true)
    }
    
    private func setViewValues() {
        if let habit = habit {
            guard let name = habit.name,
                  let descriptionString = habit.descriptionString,
                  let weekDaysInts = habit.weekdaysToRepeat,
                  let notification = habit.notificationTime else { return }
            habitEditorView.setValues(
                name: name,
                description: descriptionString,
                weekDaysString: getWeekDaysString(fromInts: weekDaysInts),
                notificationValueString: notification
            )
        } else {
            guard let name = creatingHabit.name,
                  let descriptionString = creatingHabit.descriptionString,
                  let notification = creatingHabit.notificationTime else { return }
            let weekDaysInts = creatingHabit.weekdaysToRepeat
            habitEditorView.setValues(
                name: name,
                description: descriptionString,
                weekDaysString: getWeekDaysString(fromInts: weekDaysInts),
                notificationValueString: notification
            )
        }
    }
    
    private func configureNavigationBar() {
        title = state == .create ? "Новая привычка" : habit!.name
        let rightButtonText = state == .create ? "Создать" : "Готово"
        doneButton = UIBarButtonItem(
            title: rightButtonText,
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    private func getWeekDaysString(fromInts weekDaysInts: [Int]) -> String {
        let weekDaysStrings = weekDaysInts.compactMap { (weekDayInt) -> String? in
            switch weekDayInt {
            case 0:
                return "Пн"
            case 1:
                return "Вт"
            case 2:
                return "Ср"
            case 3:
                return "Чт"
            case 4:
                return "Пт"
            case 5:
                return "Сб"
            case 6:
                return "Вс"
            default:
                return nil
            }
        }
        return weekDaysStrings.joined(separator: " ")
    }
    
    
    @objc private func doneButtonTapped() {
        switch state {
        case .create:
            _ = dbService.createHabit(
                name: creatingHabit.name!,
                descriptionString: creatingHabit.descriptionString,
                imageName: creatingHabit.image.rawValue,
                weekdaysToRepeat: creatingHabit.weekdaysToRepeat,
                notificationTime: creatingHabit.notificationTime
            )
        case .edit:
            print("edit")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
