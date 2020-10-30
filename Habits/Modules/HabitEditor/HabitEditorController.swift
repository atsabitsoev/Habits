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
        if state == .create {
            checkDoneButton()
            creatingHabit.weekdaysToRepeat = [0,1,2,3,4,5,6]
        }
        setViewValues()
    }
    
    
    func setName(_ name: String) {
        creatingHabit.name = name
        checkDoneButton()
    }
    
    func setDescription(_ description: String) {
        creatingHabit.descriptionString = description
        checkDoneButton()
    }
    
    func setImageName(_ imageName: String) {
        guard let image = HabitImage(rawValue: imageName) else { return }
        creatingHabit.image = image
        checkDoneButton()
    }
    
    func addWeekDayToRepeat(_ weekDay: Int) {
        if creatingHabit.weekdaysToRepeat == nil {
            creatingHabit.weekdaysToRepeat = habit?.weekdaysToRepeat ?? []
        }
        if let weekDays = creatingHabit.weekdaysToRepeat, !weekDays.contains(weekDay) {
            creatingHabit.weekdaysToRepeat?.append(weekDay)
        }
        creatingHabit.weekdaysToRepeat?.sort(by: {$0 < $1})
        checkDoneButton()
    }
    
    func deleteWeekDayToRepeat(_ weekDay: Int) {
        if creatingHabit.weekdaysToRepeat == nil {
            creatingHabit.weekdaysToRepeat = habit?.weekdaysToRepeat ?? []
        }
        if let weekDays = creatingHabit.weekdaysToRepeat, weekDays.contains(weekDay) {
            creatingHabit.weekdaysToRepeat?.remove(at: weekDays.firstIndex(of: weekDay)!)
        }
        creatingHabit.weekdaysToRepeat?.sort(by: {$0 < $1})
        checkDoneButton()
    }
    
    func setNotificationTime(_ notifTime: String?) {
        creatingHabit.notificationTime = notifTime
        checkDoneButton()
    }
    
    
    private func checkDoneButton() {
        doneButton.isEnabled = !(creatingHabit.name?.isEmpty ?? habit?.name?.isEmpty ?? true)
    }
    
    private func setViewValues() {
        if let habit = habit {
            guard let name = habit.name else { return }
            let descriptionString = habit.descriptionString
            let weekDaysInts = habit.weekdaysToRepeat
            let notification = habit.notificationTime
            habitEditorView.setValues(
                name: name,
                description: descriptionString,
                weekDays: weekDaysInts,
                notificationValueString: notification
            )
        } else {
            let name = creatingHabit.name
            let descriptionString = creatingHabit.descriptionString
            let notification = creatingHabit.notificationTime
            let weekDaysInts = creatingHabit.weekdaysToRepeat
            
            habitEditorView.setValues(
                name: name,
                description: descriptionString,
                weekDays: weekDaysInts,
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
        doneButton.isEnabled = false
        navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    
    @objc private func doneButtonTapped() {
        switch state {
        case .create:
            _ = dbService.createHabit(
                name: creatingHabit.name!,
                descriptionString: creatingHabit.descriptionString,
                imageName: creatingHabit.image?.rawValue ?? HabitImage.sport.rawValue,
                weekdaysToRepeat: creatingHabit.weekdaysToRepeat ?? [],
                notificationTime: creatingHabit.notificationTime
            )
        case .edit:
            guard let id = habit?.objectID.uriRepresentation().absoluteString else { return }
            dbService.editHabit(
                withId: id,
                descriptionString: creatingHabit.descriptionString,
                imageName: creatingHabit.image?.rawValue,
                name: creatingHabit.name,
                notificationTime: creatingHabit.notificationTime,
                weekdaysToRepeat: creatingHabit.weekdaysToRepeat
            )
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
