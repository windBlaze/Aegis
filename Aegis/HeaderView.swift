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
    let greenGradient = NSColor.init(patternImage: NSImage(named: "green")!)
    let redGradient = NSColor.init(patternImage: NSImage(named: "red")!)
    let blackGradient = NSColor.init(patternImage: NSImage(named: "black")!)
    let orangeGradient = NSColor.init(patternImage: NSImage(named: "orange")!)

    
    @IBOutlet weak var headerImage: NSImageView!
    
    override func awakeFromNib(){
        headerImage.image = NSImage(named: "whiteEagle")
        changeBackground(toColor: orangeGradient)
    }
    
    private func changeBackground (toColor:NSColor) {
        if (backgroundBox.fillColor != toColor) {
            DispatchQueue.main.async {
                self.backgroundBox.fillColor = toColor
            }
        }
    }
    
    func setHeaderOff() {
        changeBackground(toColor: orangeGradient)
    }
    
    
    func setHeaderMonitoring() {
        changeBackground(toColor: greenGradient)
    }
    
    func setHeaderAttack() {
        changeBackground(toColor: redGradient)
    }
}
