//
//  Date+Additions.swift
//  Today
//
//  Created by Milton Leung on 2017-07-27.
//  Copyright © 2017 milton. All rights reserved.
//

import Foundation

extension Date {
    private static let apiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()

    static func date(from string: String) -> Date? {
        return Date.apiFormatter.date(from: string)
    }
}
