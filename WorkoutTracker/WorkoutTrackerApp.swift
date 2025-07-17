//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

@main
struct WorkoutTrackerApp: App {
    @StateObject private var logStorage = LogStorage()
    
    var body: some Scene {
        WindowGroup {
            WorkoutsView(workouts: Workout.sampleData)
        }
    }
}
