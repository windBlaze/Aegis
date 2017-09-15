//
//  ArpWeaver.swift
//  Aegis
//
//  Created by Théo Rigas on 29/07/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class ArpWeaver {
    
    func getSSID() -> String? {
        let airportOutput:String = shellWithPipe(firstLaunchPath: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport", firstArguments: ["-I"], secondLaunchPath: "/usr/bin/awk", secondArguments: ["/ SSID/ {print substr($0, index($0, $2))}"])
        //print(airportOutput)
        if !airportOutput.isEmpty {
            return airportOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        else {
            return nil
        }
    }
    
    private func shellWithPipe(firstLaunchPath:String, firstArguments: [String], secondLaunchPath:String, secondArguments: [String]) -> String {
        
        let pipe = Pipe()
        
        let echo = Process()
        echo.launchPath = firstLaunchPath
        echo.arguments = firstArguments
        echo.standardOutput = pipe
        
        let uniq = Process()
        uniq.launchPath = secondLaunchPath
        uniq.arguments = secondArguments
        uniq.standardInput = pipe
        
        let out = Pipe()
        uniq.standardOutput = out
        
        echo.launch()
        uniq.launch()
        uniq.waitUntilExit()
        
        let data = out.fileHandleForReading.readDataToEndOfFile()
        let output = String(bytes: data, encoding: String.Encoding.utf8)!
        
        return output
    }
    
    
    private func shell(launchPath: String, arguments: [String]) -> String {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(bytes: data, encoding: String.Encoding.utf8)!
        return output
    }
    
    public func getGatewayIP() -> String? {
        let routeOutput:String = shell(launchPath: "/sbin/route", arguments: ["-n","get","default"])
        let components = routeOutput.components(separatedBy: "\n")
        if components.count >= 4 {
            let gateway = components[3].trimmingCharacters(in: .whitespacesAndNewlines)
            let gatewayIP = gateway.components(separatedBy: " ")[1]
            return gatewayIP
        }
        else {
            return nil
        }
    }
    
    public func getMAC(forIP: String) -> String? {
        let arpTable = getArpTable()
        return arpTable[forIP] // not unwrapped, if key not in there this is nil 
    }
    
    private func getArpTable() -> [String:String] {
        var arpTable = [String: String]()
        
        let arpOutput = shell(launchPath: "/usr/sbin/arp", arguments: ["-a"])
        let arpEntries = arpOutput.components(separatedBy: "\n")
        
        for entry:String in arpEntries {
            if !entry.isEmpty {
                //print(entry)
                let comp = entry.components(separatedBy: " ")
                var ip = comp[1]
                ip.remove(at: ip.index(before: ip.endIndex))
                ip.remove(at: ip.startIndex)
                let mac = comp[3]
                arpTable[ip] = mac
            }
        }
        return arpTable
    }
    
}

