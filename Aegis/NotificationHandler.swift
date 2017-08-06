//
//  NotificationHandler.swift
//  Aegis
//
//  Created by Théo Rigas on 5/08/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Foundation

class NotificationHandler {
    
    var notificationCenter:NSUserNotificationCenter?

    init() {
        notificationCenter = NSUserNotificationCenter.default
    }
    
    private func sendNotification(withTitle:String, withSubtitle:String) {
        let notification = NSUserNotification()
        notification.title = withTitle
        notification.subtitle = withSubtitle
        notificationCenter!.deliver(notification)
    }
    
    public func sendWiFiDisconnectNotification() {
        sendNotification(withTitle: "Aegis Update", withSubtitle: "WiFi disconnected...")
    }
    
    public func sendAttackNotification() {
        sendNotification(withTitle: "Aegis Warning", withSubtitle: "Under attack!")
    }
    
    public func sendWiFiChangeNotification() {
        sendNotification(withTitle: "Aegis Update", withSubtitle: "WiFi AP changed")
    }
    
    
}
