//
//  HeaderView.swift
//  Aegis
//
//  Created by Théo Rigas on 7/08/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Cocoa

extension NSView {
    
    var backgroundColor: NSColor? {
        
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}


class HeaderView: NSView {
    
    let greenColor = NSColor(red: 28.0, green: 61.0, blue: 11.0, alpha: 1)
    let blackColor = NSColor.black
    let redColor = NSColor(red: 30.0, green: 0.0, blue: 6.0, alpha: 0.5)

    
    
    @IBOutlet weak var headerImage: NSImageView!
    
    override func awakeFromNib(){
        self.backgroundColor = greenColor
        headerImage.image = NSImage(named: "whiteEagle")
        headerImage.backgroundColor = NSColor.clear
        //headerImage.backgroundColor = NSColor.clear
        //self.backgroundColor = NSColor(red: 49.0, green: 104.0, blue: 19.0, alpha: 1.0)
    }
    
    func setHeaderMonitoring() {
        if (backgroundColor != greenColor ) {
            DispatchQueue.main.async {
                self.backgroundColor = self.greenColor
            }
        }
    }
    
    func setHeaderAttack() {
        if !(backgroundColor == redColor) {
            DispatchQueue.main.async {
                self.backgroundColor = self.redColor
            }
        }
    }
}
