//
//  StatusView.swift
//  Aegis
//
//  Created by Théo Rigas on 29/07/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Cocoa

enum ControlState {
    case ON
    case OFF
}

protocol StatusViewDelegate {
    func onControlChange(state: ControlState)
}

class StatusView: NSView {
    @IBOutlet weak var onOffControl: NSSegmentedControl!
    @IBOutlet weak var APDetailsLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    
    var delegate: StatusViewDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func setOnOffState(enabled: Bool) {
        onOffControl.setEnabled(enabled, forSegment: 0)
    }
    
    func updateAPDetails(withIP: String, withMAC: String) {
        DispatchQueue.main.async {
            self.APDetailsLabel.maximumNumberOfLines = 3
            self.APDetailsLabel.stringValue = "AP Details:\n[IP]: \(withIP) \n[MAC]: \(withMAC)"
        }
    }
    
    func manuallyTurnOff() {
        onOffControl.selectSegment(withTag: 1)
        onOnOffControlChange(self.onOffControl)
        //onOffControl.selectedSegment = 1
        //#onOffControl.sendAction(.valueChanged, to: self)
    }
    
    func updateStatus(withMessage: String ) {
        DispatchQueue.main.async {
            self.statusLabel.stringValue = "Status: \(withMessage)"
            self.statusLabel.setNeedsDisplay()
        }
    }
    
    @IBAction func onOnOffControlChange(_ sender: NSSegmentedControl) {
        Swift.print("alerting for state change")
        if (sender.isSelected(forSegment: 0)) { // on
            //gatewayMAC = arpWeaver.getMAC(forIP: gatewayIP)
            //self.startControl()
            //sender.setEnabled(false, forSegment: 1)
            delegate?.onControlChange(state: ControlState.ON)
        } else { // off
            delegate?.onControlChange(state: ControlState.OFF)
        }
    }
    
}
