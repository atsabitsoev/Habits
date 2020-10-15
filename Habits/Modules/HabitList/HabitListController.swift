//
//  HabitListController.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 16.10.2020.
//

import UIKit

final class HabitListController: UIViewController, HabitListControlling {
    
    private var habitListView: HabitListViewing!
    
    
    override func loadView() {
        super.loadView()
        habitListView = HabitListView(controller: self)
        view = habitListView
        habitListView.configureView()
    }
    
}
