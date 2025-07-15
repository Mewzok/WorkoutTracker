//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation
import ThemeKit

struct Workout: Identifiable {
    let id: UUID
    var name: String
    var theme: Theme
    var exercises: [String]
    
    init(id: UUID = UUID(), name: String, theme: Theme, exercises: [String]) {
        self.id = id
        self.name = name
        self.theme = theme
        self.exercises = exercises
    }
}
