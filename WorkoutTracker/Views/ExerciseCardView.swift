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
                    .foregroundColor(exercise.theme.accentColor)
                
                Text("\(exercise.sets)x\(exercise.currentReps) @ \(exercise.currentWeight, specifier: "%.1f") lbs")
                    .foregroundColor(exercise.theme.accentColor.opacity(0.8))
                
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(exercise.theme.mainColor))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
        )
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 60)) {
    let exercise = Exercise.sampleData[0]
    ExerciseCardView(exercise: exercise)

}
