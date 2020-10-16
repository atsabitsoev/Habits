//
//  Habit+CoreDataProperties.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 17.10.2020.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var descriptionString: String?
    @NSManaged public var imageName: String?
    @NSManaged public var weekdaysToRepeat: [Int]?
    @NSManaged public var notificationTime: String?
    @NSManaged public var dayCount: NSNumber?
    @NSManaged public var lastDateDone: Date?

}

extension Habit : Identifiable {

}
