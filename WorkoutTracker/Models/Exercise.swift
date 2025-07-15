//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation
import ThemeKit

struct Exercise: Identifiable {
    let id: UUID
    var name: String
    var sets: Int
    var minReps: Int
    var maxReps: Int
    var warmupSets: Int
    var progressHistory: [ProgressEntry]
    var theme: Theme
    
    var currentWeight: Double {
        progressHistory.last?.weight ?? 0
    }
    
    var currentReps: Int {
        progressHistory.last?.reps ?? 0
    }
    
    var lastProgressDate: Date? {
        progressHistory.last?.date
    }
    
    init(id: UUID = UUID(), name: String, sets: Int, minReps: Int, maxReps: Int, warmupSets: Int, progressHistory: [ProgressEntry], theme: Theme) {
        self.id = id
        self.name = name
        self.sets = sets
        self.minReps = minReps
        self.maxReps = maxReps
        self.warmupSets = warmupSets
        self.progressHistory = progressHistory
        self.theme = theme
    }
}
