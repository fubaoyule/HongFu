//
//  Date+Extension.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import Foundation

enum dateType {
    case all,year,month,day,hour,minutes,secends,miniSecends
}

extension NSDate {
    
    
    
    class func getDate(type:dateType) -> String {
        
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString:String = dateFormatter.string(from: Date())
        //var dates:[String] = dateString.componentsSeparatedByString("/")
        var dates:[String] = dateString.components(separatedBy: "/")
        let currentYear  = dates[0]
        let currentMonth = dates[1]
        let currentDay   = dates[2]
        switch type {
        case .all:
            return dateString
        case .year:
            return currentYear
        case .month:
            return currentMonth
        case .day:
            return currentDay
        default:
            tlPrint(message: "no such case")
            return dateString
        }
    }
    
    class func getTime(type:dateType) -> String {
        
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "HH/mm/ss"
        let dateString:String = dateFormatter.string(from: Date())
        //var dates:[String] = dateString.componentsSeparatedByString("/")
        var dates:[String] = dateString.components(separatedBy: "/")
        let currentHour  = dates[0]
        let currentMinutes = dates[1]
        let currentSecends   = dates[2]
//        tlPrint(message: "currentTime = \(dates)")
        switch type {
        case .all:
            return dateString
        case .hour:
            return currentHour
        case .minutes:
            return currentMinutes
        case .secends:
            return currentSecends
        default:
            tlPrint(message: "no such case")
            return dateString
        }
    }
}
