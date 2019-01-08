//
//  Date+Ext.swift
//  ChatUIKit
//
//  Created by Gustavo Halperin on 12/22/18.
//  Copyright © 2018 iDeasTouch SA. All rights reserved.
//

import Foundation


extension NSObject {
    convenience init( attributeDictionary:NSDictionary) {
        self.init()
        for (key, value) in attributeDictionary {
            if let string = key as? String {
                self.setValue(value, forKey:string) } } }
    
    convenience init( attributeDictionary:[String:Any?]) {
        self.init()
        for (key, value) in attributeDictionary {
            self.setValue(value, forKey:key) } }
}

extension TimeZone {
    static var utc:TimeZone? { get { return TimeZone(abbreviation: "UTC") } }
}


extension DateFormatter {
    enum DateFormat: String {
        case Date = "MMMM d, yyyy"
        case When = "EEEE, MMMM d"
        case Month = "MMMM"
        case Day = "d"
        case Time = "h:mma"
        case Key = "yyyyMMddHHmm"
        
        case Month3Year4 = "MMM yyyy" }
    
    convenience init(timeZone:TimeZone?, dateFormat:DateFormat? = nil) {
        if let dateFormat = dateFormat {
            self.init(attributeDictionary: ["timeZone": timeZone, "dateFormat": dateFormat.rawValue]) }
        else {
            if let timeZone = timeZone {
                self.init(attributeDictionary: ["timeZone": timeZone]) }
            else {
                self.init(attributeDictionary: ["timeZone": TimeZone.utc]) } } }
}

/*
 Date Extesion with an sugestion of how implement the computer variable 'timeStr' and 'dateStr' using a given Date.
 */
extension Date {
    func datePostfix(_ number:Int) -> String {
        switch number {
        case 1, 21, 31:
            return "ST"
        case 2, 22:
            return "ND"
        case 3, 23:
            return "RD"
        default:
            return "TH" } }
    
    public var chatUIKitTimeStr: String? {
        let timeStr = DateFormatter(timeZone: TimeZone.autoupdatingCurrent, dateFormat: .Time).string(from: self)
        return timeStr.uppercased() }
    
    public var chatUIKitDayStr: String? {
        var when = DateFormatter(timeZone: TimeZone.autoupdatingCurrent, dateFormat: .When).string(from: self)
        if let day = Int(DateFormatter(timeZone: TimeZone.autoupdatingCurrent, dateFormat: .Day).string(from: self)) {
            when += self.datePostfix(day).lowercased() }
        return when }
}
