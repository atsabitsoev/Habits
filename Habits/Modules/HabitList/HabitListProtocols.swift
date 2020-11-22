//
//  HabitListProtocols.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 16.10.2020.
//

import UIKit

protocol HabitListControlling: UIViewController {
    func dayCountChanged(entityId: String, newDayCount: Int, todayDone: Bool)
    func editHabitAction(withId id: String)
    func deleteHabitAction(withId id: String)
}

protocol HabitListViewing: UIView {
    func configureView()
    func setItems(_ items: [HabitItem])
    func deleteHabit(atRow row: Int)
}
