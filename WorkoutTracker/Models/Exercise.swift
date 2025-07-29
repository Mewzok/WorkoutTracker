//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable {
    var name: String
    var sets: Int
    var minReps: Int
    var maxReps: Int
    var warmupSets: Int
    
    @Relationship(deleteRule: .cascade)
    var progressHistory: [ProgressEntry] = []
    
    var currentWeight: Double {
        progressHistory.last?.weight ?? 0
    }
    
    var currentReps: Int {
        progressHistory.last?.reps ?? 0
    }
    
    var lastProgressDate: Date? {
        progressHistory.last?.date
    }
    
    init(name: String, sets: Int, minReps: Int, maxReps: Int, warmupSets: Int, progressHistory: [ProgressEntry]) {
        self.name = name
        self.sets = sets
        self.minReps = minReps
        self.maxReps = maxReps
        self.warmupSets = warmupSets
        self.progressHistory = progressHistory
    }
}
