//
//  String+Extension.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 29.10.2020.
//

import Foundation

extension String {
    func timeDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.date(from: self)
    }
}
