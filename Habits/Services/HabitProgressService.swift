//
//  HabitProgressService.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 16.10.2020.
//

import Foundation

final class HabitProgressService {
    
    private let levels = (7, 21, 40, 90)
    
    ///Функция возвращает два значения - Уровень и процент его выполнения
    func getProgress(daysCompleted: Int) -> (Int, Float) {
        switch daysCompleted {
        case 0...levels.0:
            let progress = Float(daysCompleted) / Float(levels.0)
            return (0, progress)
        case (levels.0 + 1)...levels.1:
            let progress = Float(daysCompleted) / Float(levels.1)
            return (1, progress)
        case (levels.1 + 1)...levels.2:
            let progress = Float(daysCompleted) / Float(levels.2)
            return (2, progress)
        case (levels.2 + 1)...levels.3:
            let progress = Float(daysCompleted) / Float(levels.3)
            return (3, progress)
        default:
            return (3, 1)
        }
    }
    
    func isStartOfLevel(daysCompleted: Int) -> Bool {
        let allLevels = [levels.0, levels.1, levels.2, levels.3]
        return allLevels.contains(daysCompleted)
    }
    
}
