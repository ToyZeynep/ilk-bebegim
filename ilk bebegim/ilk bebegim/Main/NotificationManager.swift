//
//  NotificationManager.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import Foundation
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()

    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
        }
    }

    func scheduleDailyReminder(hour: Int = 10, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "🍼Günün İpucu"
        content.body = "Bebeğinizin gelişimini desteklemek için bugünün ipuçlarına göz atın!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyTipReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
