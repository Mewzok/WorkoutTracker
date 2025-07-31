//
//  ExerciseListRowView.swift
//  WorkoutTracker
//
//  Created by Student on 7/31/25.
//  Parent view for single row of exercise name

import SwiftUI

struct ExerciseListRowView: View {
    let exercise: Exercise
    var trailingButtons: AnyView?
    
    var body: some View {
        HStack {
            Text(exercise.name)
                .font(.headline)
            Spacer()
            if let trailingButtons = trailingButtons {
                trailingButtons
            }
        }
    }
}

#Preview {
    ExerciseListRowView(exercise: Exercise(name: "EX Name", sets: 3, minReps: 4, maxReps: 6, warmupSets: 0, progressHistory: []))
}
