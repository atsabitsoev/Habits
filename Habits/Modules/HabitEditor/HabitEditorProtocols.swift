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
    func setImage(_ image: HabitImage)
    func addWeekDayToRepeat(_ weekDay: Int)
    func deleteWeekDayToRepeat(_ weekDay: Int)
    func setNotificationTime(_ notifTime: String?)
}

protocol HabitEditorViewing: UIView {
    func configureView()
    func setValues(name: String?, description: String?, image: HabitImage, weekDays: [Int]?, notificationValueString: String?)
    func showKeyboard()
}
