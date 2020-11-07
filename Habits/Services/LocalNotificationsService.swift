//
//  LocalNotificationsService.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 07.11.2020.
//

import UserNotifications

final class LocalNotificationsService {
    
    func createNotification(
        id: String,
        title: String,
        subTitle: String,
        body: String?,
        weekDays: [Int],
        hour: Int,
        minute: Int
    ) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        if let body = body {
            content.body = body
        }
        content.sound = UNNotificationSound.default
        
        let triggers = weekDays.map { (weekday) -> UNCalendarNotificationTrigger in
            let notFormatterWeekDay = weekday > 5 ? 1 : weekday + 2
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: DateComponents(
                    hour: hour,
                    minute: minute,
                    weekday: notFormatterWeekDay
                ),
                repeats: true
            )
            return trigger
        }
        
        let requests = triggers.map { (trigger) -> UNNotificationRequest in
            print(id + "\(trigger.dateComponents.weekday ?? 0)")
            let request = UNNotificationRequest(
                identifier: id + "\(trigger.dateComponents.weekday ?? 0)",
                content: content,
                trigger: trigger
            )
            return request
        }
        
        requests.forEach { (request) in
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Уведомление добавлено")
                }
            }
        }
        
    }
    
    func removeNotification(id: String, weekDays: [Int]) {
        let identifiers = weekDays.map({ id + "\($0)" })
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("Удалено уведомлений: \(identifiers.count)")
    }
    
}
