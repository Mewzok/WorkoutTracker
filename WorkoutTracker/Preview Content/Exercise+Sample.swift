//
//  Exercise+Sample.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import Foundation
import ThemeKit

extension Exercise {
    static func stub(named name: String) -> Exercise {
        Exercise(name: name, sets: 3, minReps: 10, maxReps: 12, warmupSets: 0, progressHistory: [ ProgressEntry(date: Date(), weight: 100.0, reps: 10)])
    }
    
    static let sampleData: [Exercise] = [
        Exercise.stub(named: "Barbell Deadlift"),
        Exercise.stub(named: "Chest Supported Row"),
        Exercise.stub(named: "Dumbbell LAT Pullover"),
        Exercise.stub(named: "Dumbbell High Pull"),
        Exercise.stub(named: "Bicep Chin Curl"),
        Exercise.stub(named: "Overhead Triceps Extension"),
        Exercise.stub(named: "Angels and Devils"),
        Exercise.stub(named: "Barbell Bench Press"),
        Exercise.stub(named: "Butterfly Press"),
        Exercise.stub(named: "Dumbbell Shoulder Press"),
        Exercise.stub(named: "1 1/2 Side Lateral Raise"),
        Exercise.stub(named: "Lying Triceps Extension"),
        Exercise.stub(named: "Dumbbell Waiter's Curl"),
        Exercise.stub(named: "Rotator Cuff Extension"),
        Exercise.stub(named: "Barbell Squat"),
        Exercise.stub(named: "Barbell Hip Thrust"),
        Exercise.stub(named: "Dumbbell Reverse Lunge"),
        Exercise.stub(named: "Dumbbell Single Leg RDL"),
        Exercise.stub(named: "Standing Dumbbell Calf Raise")
    ]
}
