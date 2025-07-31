//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation
import SwiftData
import ThemeKit

@Model
class Workout: Identifiable {
    var name: String
    var theme: Theme
    var exercises: [Exercise]
    var day: String?
    
    init(name: String, theme: Theme, exercises: [Exercise], day: String?) {
        self.name = name
        self.theme = theme
        self.exercises = exercises
        self.day = day
    }
}
