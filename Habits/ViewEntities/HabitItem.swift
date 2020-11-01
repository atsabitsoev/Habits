//
//  HabitItem.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 15.10.2020.
//

import Foundation

struct HabitItem {
    var id: String
    var name: String
    var descriptionString: String?
    var image: HabitImage
    var dayCount: Int
    var isShownFullDescription: Bool = false
    var todayDone: Bool
}

enum HabitImage: String {
    case sport = "runningIcon"
    case book
    case water
    case writing
    case yoga
    case handshake
    case money
    case phone
    case atom
    case languages
    case lunges
}
