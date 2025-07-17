//
//  DailyLog.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import Foundation

struct DailyLog: Codable, Identifiable {
    var id: UUID = UUID()
    let date: Date
    var note: String
}
