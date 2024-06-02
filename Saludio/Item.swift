//
//  Item.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-02.
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
