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
    }
    
    
    private func configureNavigationBar() {
        title = state == .create ? "Новая привычка" : habit!.name
    }
    
}
