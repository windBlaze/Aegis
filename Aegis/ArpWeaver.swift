//
//  ArpWeaver.swift
//  Aegis
//
//  Created by Théo Rigas on 29/07/17.
//  Copyright © 2017 Black Monkeys Corporation. All rights reserved.
//

import Foundation

class ArpWeaver {
    
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
    
    public func getGatewayIP() -> String {
        let routeOutput:String = shell(launchPath: "/sbin/route", arguments: ["-n","get","default"])
        let gateway = routeOutput.components(separatedBy: "\n")[3].trimmingCharacters(in: .whitespacesAndNewlines)
        let gatewayIP = gateway.components(separatedBy: " ")[1]
        return gatewayIP
    }
    
    public func getMAC(forIP: String) -> String {
        let arpTable = getArpTable()
        return arpTable[forIP]!
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

