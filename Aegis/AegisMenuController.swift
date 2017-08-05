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
    var accessPointIP:String?
    var accessPointMAC:String?
    
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
        /*ControlTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.checkMAC()
        }*/
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
        startAPTimer()
    }
    
    func checkMAC() {
        print("Mac checked")
        let currentAccessPointMAC = arpWeaver.getMAC(forIP: accessPointIP!)
        print(currentAccessPointMAC)
        print(accessPointMAC!)
        let underAttack:Bool = (currentAccessPointMAC != accessPointMAC)
        if underAttack {
            notifyAttack()
        }
        else {
            notifyOK()
        }
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
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return(" [ \(hour):\(minutes):\(seconds) ]")
    }
    
    func updateAPDetails() {
        print("AP details updated")
        accessPointIP = arpWeaver.getGatewayIP()
        accessPointMAC = arpWeaver.getMAC(forIP: accessPointIP!)
        statusView.updateAPDetails(withIP: accessPointIP!, withMAC: accessPointMAC!)
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

