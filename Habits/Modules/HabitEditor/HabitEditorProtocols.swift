//
//  HabitEditorProtocols.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 19.10.2020.
//

import UIKit

protocol HabitEditorControlling: UIViewController {
}

protocol HabitEditorViewing: UIView {
    func configureView()
    func setValues(name: String, description: String, weekDaysString: String, notificationValueString: String)
}
