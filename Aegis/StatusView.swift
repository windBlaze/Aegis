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

class StatusView: NSView,NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var onOffControl: NSSegmentedControl!
    @IBOutlet weak var rememberCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    var delegate: StatusViewDelegate?
    
    var tableViewData = [["leftInfo":"DETAILS","rightInfo":""],
                         ["leftInfo":"IP","rightInfo":"Loading ..."],
                         ["leftInfo":"MAC","rightInfo":"Loading ..."],
                         ["leftInfo":"STATUS", "rightInfo":""],
                         ["leftInfo":"OFF","rightInfo":""]
    ]
    
    let IPRow = 1
    let MACRow = 2
    let StatusRow = 4
    let headerRows = [0,3]
    //let padLength = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //onOffControl.setImage(NSImage(named: "shieldGreen"), forSegment: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        
        
        if (headerRows.contains(row)) { // header row
            //Header Row
            let result = tableView.make(withIdentifier: "TableCell", owner: self) as! NSTableCellView
            result.textField?.stringValue = tableViewData[row][tableColumn!.identifier]!
            result.textField?.font = NSFont.boldSystemFont(ofSize: (result.textField?.font?.pointSize)!)
            return result
        }
        else{
            let result = tableView.make(withIdentifier: "TableCell", owner: self) as! NSTableCellView
            result.textField?.stringValue = tableViewData[row][tableColumn!.identifier]!
            if tableColumn!.identifier == "rightInfo" {
                result.textField?.font = NSFont.boldSystemFont(ofSize: (result.textField?.font?.pointSize)!)
                result.textField?.alignment = .right
            }
            return result
        }
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
            //self.APDetailsLabel.maximumNumberOfLines = 3
            //self.APDetailsLabel.stringValue = "AP Details:\n[IP]: \(withIP) \n[MAC]: \(withMAC)"
            self.tableViewData[self.IPRow]["rightInfo"] = withIP
            self.tableViewData[self.MACRow]["rightInfo"] = withMAC
            self.tableView.reloadData()
        }
        //tableViewData[IPRow]["itemInfo"] = withIP
        //tableView.reloadData()
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
    
    func updateStatus(withHeader: String, withInfo: String ) {
        DispatchQueue.main.async {
            //self.statusLabel.stringValue = "Status: \(withMessage)"
            //self.statusLabel.setNeedsDisplay()
            self.tableViewData[self.StatusRow]["leftInfo"] = withHeader
            self.tableViewData[self.StatusRow]["rightInfo"] = withInfo
            //self.tableViewData[self.MACRow]["itemInfo"] = withMAC
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onOnOffControlChange(_ sender: NSSegmentedControl) {
        //Swift.print("on off state change")
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
        //Swift.print("remember state change")
        if (sender.state == NSOnState) { //
            delegate?.onRememberChange(state: .YES)
        }
        else { // off
            delegate?.onRememberChange(state: .NO)
        }
    }
    
}
