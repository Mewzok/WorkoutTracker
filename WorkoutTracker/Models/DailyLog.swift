//
//  DailyLog.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import Foundation
import SwiftData

@Model
class DailyLog: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var note: String
    
    init(id: UUID = UUID(), date: Date, note: String) {
        self.id = id
        self.date = date
        self.note = note
    }
}
