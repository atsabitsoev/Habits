//
//  Date+Extensions.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 29.10.2020.
//

import Foundation

extension Date {
    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: self)
    }
}
