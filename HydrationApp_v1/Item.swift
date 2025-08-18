//
//  Item.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
