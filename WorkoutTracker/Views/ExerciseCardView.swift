//
//  ExerciseCardView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct ExerciseCardView: View {
    let exercise: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.headline)
                
                Text("\(exercise.sets)x\(exercise.currentReps) @ \(exercise.currentWeight, specifier: "%.1f") lbs")
                
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
        )
    }
}

#Preview() {
    let exercise = Exercise.sampleData[0]
    ExerciseCardView(exercise: exercise)

}
