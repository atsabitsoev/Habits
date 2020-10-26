//
//  HabitEditorProtocols.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 19.10.2020.
//

import UIKit

protocol HabitEditorControlling: UIViewController {
    func setName(_ name: String)
    func setDescription(_ description: String)
    func setImageName(_ imageName: String)
    func setWeekDays(_ weekDays: [Int])
    func setNotificationTime(_ notifTime: String)
}

protocol HabitEditorViewing: UIView {
    func configureView()
    func setValues(name: String, description: String, weekDaysString: String, notificationValueString: String)
}
