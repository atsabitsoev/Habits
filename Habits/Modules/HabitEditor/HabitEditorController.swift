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
    
    private let habit: Habit?
    private let state: State
    
    
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
        }
    }
    
    
    private func configureNavigationBar() {
        title = state == .create ? "Новая привычка" : habit!.name
    }
    
    private func getWeekDaysString(fromInts weekDaysInts: [Int]) -> String {
        let weekDaysStrings = weekDaysInts.compactMap { (weekDayInt) -> String? in
            switch weekDayInt {
            case 0:
                return "ВС"
            case 1:
                return "ПН"
            case 2:
                return "ВТ"
            case 3:
                return "СР"
            case 4:
                return "ЧТ"
            case 5:
                return "ПТ"
            case 6:
                return "СБ"
            default:
                return nil
            }
        }
        return weekDaysStrings.joined(separator: " ")
    }
    
}
