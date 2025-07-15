//
//  ProgressEntry.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation

struct ProgressEntry: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
    let reps: Int
}
