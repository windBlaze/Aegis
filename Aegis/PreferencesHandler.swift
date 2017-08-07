//
//  PreferencesHandler.swift
//  Aegis
//
//  Created by Théo Rigas on 7/08/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Foundation

final class PreferencesHandler  {
    
    private static let prefs = UserDefaults.standard
    
    private init() {
        // static class
    }
    
    static func isAccessPointSaved(withSSID:String, withMAC:String) -> Bool{
        let key = withSSID.sha256()
        print(key)
        let hashedMAC = withMAC.sha256()
        let savedMAC = prefs.string(forKey: key)
        if (savedMAC != nil && savedMAC! == hashedMAC) {
            return true
        }
        return false
    }
    
    static func saveAccessPoint(withSSID:String, withMAC:String) {
        let key = withSSID.sha256()
        let hashedMAC = withMAC.sha256()
        prefs.set(hashedMAC, forKey: key)
    }
    
    
    static func deleteAccessPoint(withSSID:String) {
        let key = withSSID.sha256()
        prefs.removeObject(forKey: key)
    }
    
}
