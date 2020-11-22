//
//  DBService.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 17.10.2020.
//

import UIKit
import CoreData


final class DBService {
    
    func getAllHabits() -> [Habit] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habit")
        do {
            let habits = try managedContext.fetch(fetchRequest) as! [Habit]
            return habits
        } catch {
            return []
        }
    }
    
    func createHabit(
        name: String,
        descriptionString: String?,
        imageName: String,
        weekdaysToRepeat: [Int],
        notificationTime: String?,
        dayCount: Int = 0,
        lastDateDone: Date? = nil
    ) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Habit", in: managedContext)!
        
        let habit = NSManagedObject(entity: entity, insertInto: managedContext) as! Habit
        habit.name = name
        habit.descriptionString = descriptionString
        habit.imageName = imageName
        habit.weekdaysToRepeat = weekdaysToRepeat
        habit.notificationTime = notificationTime
        habit.dayCount = NSNumber(integerLiteral: dayCount)
        habit.lastDateDone = lastDateDone as NSDate?
        
        do {
            try managedContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func setNewDayCountToHabit(withId id: String, newDayCount: Int, todayDone: Bool) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let url = URL(string: id),
              let objectId = managedContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else { return false }
        let habit = managedContext.object(with: objectId) as! Habit
        habit.dayCount = NSNumber(integerLiteral: newDayCount)
        if todayDone {
            habit.preLastDateDone = habit.lastDateDone
            habit.lastDateDone = NSDate()
        } else {
            habit.lastDateDone = habit.preLastDateDone
        }
        
        do {
            try managedContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func editHabit(
        withId id: String,
        descriptionString: String? = nil,
        imageName: String? = nil,
        name: String? = nil,
        notificationTime: String? = nil,
        weekdaysToRepeat: [Int]? = nil
        ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let url = URL(string: id),
              let objectId = managedContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else { return }
        let habit = managedContext.object(with: objectId) as! Habit
        
        if let descriptionString = descriptionString {
            habit.descriptionString = descriptionString
        }
        if let imageName = imageName {
            habit.imageName = imageName
        }
        if let name = name {
            habit.name = name
        }
        if let notificationTime = notificationTime {
            habit.notificationTime = notificationTime
        }
        if let weekdaysToRepeat = weekdaysToRepeat {
            habit.weekdaysToRepeat = weekdaysToRepeat
        }
        
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteHabit(withId id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let url = URL(string: id),
              let objectId = managedContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else { return false }
        managedContext.delete(managedContext.object(with: objectId))
        
        do {
            try managedContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
