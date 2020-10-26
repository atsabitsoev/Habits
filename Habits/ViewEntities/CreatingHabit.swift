//
//  CreatingHabit.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 27.10.2020.
//

import Foundation

struct CreatingHabit {
    
    var name: String?
    var descriptionString: String?
    var imageName: String = "runningIcon"
    var weekdaysToRepeat: [Int] = [0,1,2,3,4,5,6]
    var notificationTime: String?
}
