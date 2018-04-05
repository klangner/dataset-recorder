//
//  Extensions.swift
//  dataset-recorder
//
//  Created by Krzysztof Langner on 05/04/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import Foundation

extension Date {
    
    // Convert date to ISO format
    func isoFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
    
    // Number of seconds from epoch
    func timestamp() -> Int {
        return Int(timeIntervalSince1970)
    }
}

extension DataItem {
    func fileUrl() -> URL {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = docDir.appendingPathComponent(fileName!)
        return url
    }
}
