//
//  AegisMenuController.swift
//  Aegis
//
//  Created by Théo Rigas on 29/07/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Cocoa

class AegisMenuController: NSObject, StatusViewDelegate {
    
    @IBOutlet weak var aegisMenu: NSMenu!
    @IBOutlet weak var statusView: StatusView!
    
    // timers 
    weak var APTimer: Timer?
    weak var ControlTimer: Timer?
    
    var statusMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    let arpWeaver = ArpWeaver()
    let notificationHandler = NotificationHandler()
    var accessPointIP:String?
    var accessPointMAC:String?
    var accessPointSSID:String?
    
    override func awakeFromNib() {
        statusItem.menu = aegisMenu
        setIcon(toImage: "shield")
        
        
        // attach menu
        statusItem.menu = aegisMenu
        
        // create status view
        statusMenuItem = aegisMenu.item(withTitle: "Status")
        statusMenuItem.view = statusView
        statusView.delegate = self
        
        updateAPDetails()
        startAPTimer()
    }
    
    func startAPTimer() {
        APTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector (AegisMenuController.updateAPDetails), userInfo: nil, repeats: true)
        RunLoop.main.add(APTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func stopAPTimer() {
        APTimer?.invalidate()
    }
    
    func startControlTimer() {
        ControlTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector (AegisMenuController.checkMAC), userInfo: nil, repeats: true)
        RunLoop.main.add(ControlTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func stopControlTimer() {
        ControlTimer?.invalidate()
    }
    
    func setIcon(toImage: String) {
        DispatchQueue.main.async {
            // create icon
            let icon = NSImage(named: toImage)
            //icon?.isTemplate = true // dark mode
            self.statusItem.image = icon
        }
    }
    
    func startControl() {
        stopAPTimer()
        startControlTimer()
    }
    
    func stopControl() {
        stopControlTimer()
        updateAPDetails()
        startAPTimer()
    }
    
    func checkMAC() {
        print("Checking MAC")
        // check if still connected to the same Wi-Fi
        let currentAccessPointIP = arpWeaver.getGatewayIP()
        if currentAccessPointIP == nil || didSSIDChange() {
            // changed Wi-Fi or disconnect, turn control off
            notificationHandler.sendWiFiDisconnectNotification()
            statusView.manuallyTurnOff()
            return
        }
        let currentAccessPointMAC = arpWeaver.getMAC(forIP: accessPointIP!)
        if (currentAccessPointMAC == nil) {print("nil")}
        let underAttack:Bool = (currentAccessPointMAC != nil && currentAccessPointMAC! != accessPointMAC)
        if underAttack {
            notifyAttack()
        }
        else {
            notifyOK()
        }
    }
    
    private func didSSIDChange() -> Bool {
        let currentSSID = arpWeaver.getSSID()
        return (currentSSID != nil && currentSSID! != accessPointSSID!)
    }
    
    func notifyAttack() {
        setIcon(toImage: "shieldRed")
        statusView.updateStatus(withMessage: "Under Attack!")
    }
    
    func notifyOK() {
        setIcon(toImage: "shieldGreen")
        statusView.updateStatus(withMessage: "\(getTimestamp()) OK!")
    }
    
    private func getTimestamp() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = String(format: "%02d", calendar.component(.hour, from: date))
        let minutes = String(format: "%02d", calendar.component(.minute, from: date))
        let seconds = String(format: "%02d", calendar.component(.second, from: date))
        return(" [ \(hour):\(minutes):\(seconds) ]")
    }
    
    func updateAPDetails() {
        print("AP details updated")
        accessPointIP = arpWeaver.getGatewayIP()
        if accessPointIP != nil {
            accessPointMAC = arpWeaver.getMAC(forIP: accessPointIP!)
            accessPointSSID = arpWeaver.getSSID()
            statusView.updateAPDetails(withIP: accessPointIP!, withMAC: accessPointMAC!)
            statusView.setOnOffState(enabled: true)
        }
        else {
            // not connected to internet
            statusView.updateAPDetails(withIP: "---", withMAC: "---")
            statusView.setOnOffState(enabled: false)
        }
    }
    
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
    
    func onControlChange(state: ControlState) {
        if state == ControlState.ON {
            setIcon(toImage: "shieldGreen")
            statusView.updateStatus(withMessage: "ON")
            startControl()
        }
        else {
            setIcon(toImage: "shield")
            statusView.updateStatus(withMessage: "OFF")
            stopControl()
        }
    }
}

