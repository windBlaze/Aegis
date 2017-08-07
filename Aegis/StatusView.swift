//
//  StatusView.swift
//  Aegis
//
//  Created by Théo Rigas on 29/07/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Cocoa

enum RememberState {
    case YES
    case NO
}

enum ControlState {
    case ON
    case OFF
}

protocol StatusViewDelegate {
    func onControlChange(state: ControlState)
    func onRememberChange(state: RememberState)
}

class StatusView: NSView {
    @IBOutlet weak var onOffControl: NSSegmentedControl!
    @IBOutlet weak var APDetailsLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var rememberCheckbox: NSButton!
    
    var delegate: StatusViewDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //onOffControl.setImage(NSImage(color: NSColor.red,size:onOffControl.subviews[1].fittingSize), forSegment: 0)
    }
    
    override func awakeFromNib() {
        //onOffControl.setImage(NSImage(named: "shieldGreen"), forSegment: 0)
    }
    
    func setOnOffState(enabled: Bool) {
        onOffControl.setEnabled(enabled, forSegment: 0)
    }
    
    func manuallyCheckRemember() {
        if (rememberCheckbox.state == NSOffState) {
            rememberCheckbox.setNextState()
        }
    }
    
    func manuallyUnCheckRemember() {
        if (rememberCheckbox.state == NSOnState) {
            rememberCheckbox.setNextState()
        }
    }
    
    func setRememberState(enabled: Bool) {
        rememberCheckbox.isEnabled = enabled
    }
    
    func updateAPDetails(withIP: String, withMAC: String) {
        DispatchQueue.main.async {
            self.APDetailsLabel.maximumNumberOfLines = 3
            self.APDetailsLabel.stringValue = "AP Details:\n[IP]: \(withIP) \n[MAC]: \(withMAC)"
        }
    }
    
    func manuallyTurnOff() {
        onOffControl.selectSegment(withTag: 1)
        // doesn't fire automatically...
        onOnOffControlChange(self.onOffControl)
    }
    
    func manuallyTurnOn() {
        onOffControl.selectSegment(withTag: 0)
        // doesn't fire automatically...
        onOnOffControlChange(self.onOffControl)
    }
    
    func updateStatus(withMessage: String ) {
        DispatchQueue.main.async {
            self.statusLabel.stringValue = "Status: \(withMessage)"
            self.statusLabel.setNeedsDisplay()
        }
    }
    
    @IBAction func onOnOffControlChange(_ sender: NSSegmentedControl) {
        Swift.print("on off state change")
        if (sender.isSelected(forSegment: 0)) { // on
            //gatewayMAC = arpWeaver.getMAC(forIP: gatewayIP)
            //self.startControl()
            //sender.setEnabled(false, forSegment: 1)
            delegate?.onControlChange(state: ControlState.ON)
        } else { // off
            delegate?.onControlChange(state: ControlState.OFF)
        }
    }
    
    @IBAction func onRememberCheckboxChange(_ sender: NSButton) {
        Swift.print("remember state change")
        if (sender.state == NSOnState) { //
            delegate?.onRememberChange(state: .YES)
        }
        else { // off
            delegate?.onRememberChange(state: .NO)
        }
    }
    
}
