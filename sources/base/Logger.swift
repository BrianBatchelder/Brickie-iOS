//
//  Logger.swift
//  Develop
//
//  Created by Work on 12/02/2019.
//  Copyright © 2019 WISIMAGE. All rights reserved.
//

import UIKit
import os.log

import os.log

let subsystem = Bundle.main.bundleIdentifier!

public func logerror(_ err:Error?,category:OSLogType.Category = .app){
    log(err?.localizedDescription ?? "Unknow Error",category:category,.error)
}
public func log(_ message:String,category:OSLogType.Category = .app,_ type : OSLogType = .debug){
    if isDebug {
        print("\(type.emoji) > \(message)")
    } else {
        os_log("%{PUBLIC}@:%{PUBLIC}@", log: OSLog(subsystem: subsystem, category: category.rawValue), type: type,type.emoji,message)
    }
}


extension OSLogType {
        var emoji : String {
            switch self {
            case .error:
                return "🚷"
            case .fault:
                return "🚸"
            case .info:
                return "✅"
            default:
                return "👾"
            }
        }
    public enum Category:String {
        case app = "app"
        case lifeCycle = "viewLifeCycle"
        case network = "network"
        case api = "api"
    }
}

let isDebug: Bool = {
    var info = kinfo_proc()
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var size = MemoryLayout.stride(ofValue: info)
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    assert(junk == 0, "sysctl failed")
    return (info.kp_proc.p_flag & P_TRACED) != 0
}()
