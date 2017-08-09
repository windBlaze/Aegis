//
//  HeaderView.swift
//  Aegis
//
//  Created by Théo Rigas on 7/08/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Cocoa

class HeaderView: NSView {
    
    @IBOutlet weak var backgroundBox: NSBox!
    let greenColor = NSColor(red: 102, green: 206, blue: 54, alpha: 1)
    let blackColor = NSColor.black
    let redColor = NSColor(red: 232, green: 63, blue: 55, alpha: 1)

    
    @IBOutlet weak var headerImage: NSImageView!
    
    override func awakeFromNib(){
        headerImage.image = NSImage(named: "whiteEagle")
    }
    
    func setHeaderOff() {
        if (backgroundBox.fillColor != blackColor ) {
            DispatchQueue.main.async {
                self.backgroundBox.fillColor = self.blackColor
            }
        }
    }
    
    
    func setHeaderMonitoring() {
        if (backgroundBox.fillColor != greenColor ) {
            DispatchQueue.main.async {
                self.backgroundBox.fillColor = self.greenColor
            }
        }
    }
    
    func setHeaderAttack() {
        if !(backgroundBox.fillColor == redColor) {
            DispatchQueue.main.async {
                self.backgroundBox.fillColor = self.redColor
            }
        }
    }
}
