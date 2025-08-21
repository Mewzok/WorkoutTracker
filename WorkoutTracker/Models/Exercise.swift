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
    
    func updateProgress(newWeight: Double, newReps: Int, on date: Date, context: ModelContext) -> String {
        let oldWeight = self.currentWeight
        let oldReps = self.currentReps
        
        var changes: [String] = []
        
        // check weight
        if newWeight != oldWeight {
            if newWeight > oldWeight {
                changes.append("Weight increased from \(String(format: "%g", oldWeight)) to \(String(format: "%g", newWeight)) lbs. ")
            } else {
                changes.append("Weight decreased to \(String(format: "%g", newWeight)) from \(String(format: "%g", oldWeight)) lbs. ")
            }
        }
        
        // check reps
        if newReps != oldReps {
            if newReps > oldReps {
                changes.append("Reps increased from \(Int(oldReps)) to \(Int(newReps)) reps. ")
            } else {
                changes.append("Reps decreased to \(Int(newReps)) from \(Int(oldReps)) reps. ")
            }
        }
        
        return changes.joined(separator: " ")
    }
}
