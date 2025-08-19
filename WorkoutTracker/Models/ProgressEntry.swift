//
//  ProgressEntry.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation
import SwiftData

@Model
class ProgressEntry: Identifiable {
    var date: Date
    var weight: Double
    var reps: Int
    var note: String
    
    init(date: Date, weight: Double, reps: Int, note: String = "") {
        self.date = date
        self.weight = weight
        self.reps = reps
        self.note = note
    }
}
