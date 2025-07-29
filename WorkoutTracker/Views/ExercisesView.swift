//
//  ExercisesView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct ExercisesView: View {
    let workout: Workout
    
    var body: some View {
        List(workout.exercises) { exercise in
            NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                ExerciseCardView(exercise: exercise)
            }
        }
        .navigationTitle("Exercises")
        .toolbar {
            Button(action: {}) {
                Image(systemName: "plus")
            }
        }
    }
}


#Preview {
    ExercisesView(workout: Workout.sampleData[0])
}
