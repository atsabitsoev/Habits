//
//  HabitListProtocols.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 16.10.2020.
//

import UIKit

protocol HabitListControlling: UIViewController {
    func dayCountChanged(entityId: String, newDayCount: Int, todayDone: Bool)
    func editHabit(withId id: String)
}

protocol HabitListViewing: UIView {
    func configureView()
    func setItems(_ items: [HabitItem])
}
