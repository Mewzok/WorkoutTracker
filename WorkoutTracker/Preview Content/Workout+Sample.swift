//
//  Workout+Sample.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation
import ThemeKit

extension Workout {
    static let sampleData: [Workout] = [
        Workout(name: "Pull 1",
                theme: .yellow,
                exercises: ["Deadlift", "Chest Supported Rows", "Dumbbell Lat Pullover", "Dumbbell High Pulls", "Bicep Chin Curls", "Overhead Triceps Extension", "Angels and Devils"]),
        Workout(name: "Push 1",
                theme: .orange,
                exercises: ["Incline Barbell Bench Press", "Butterfly Press", "Dumbbell Shoulder Press", "1 1/2 Side Lateral Raise", "Lying Tricep Extensions", "Dumbbell Waiter's Curls", "Rotator Cuff Extension"]),
        Workout(name: "Legs 1",
                theme: .poppy,
                exercises: ["Barbell Squat", "Barbell Hip Thrust", "Dumbbell Reverse Lunge", "Dumbbell Single Leg RDL", "Standing Dumbbell Calf Raise"])
    ]
}
