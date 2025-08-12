//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI
import SwiftData

@main
struct WorkoutTrackerApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                WorkoutsView()
                    .tabItem {
                        Label("Workouts", systemImage: "dumbbell")
                    }
                
                ExercisesView()
                    .tabItem {
                        Label("Exercises", systemImage: "figure.walk")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
        .modelContainer(for: [Workout.self, Exercise.self, ProgressEntry.self, DailyLog.self])
    }
}
