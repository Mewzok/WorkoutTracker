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
                    .foregroundColor(.primary)
                
                Text("\(exercise.sets)x\(exercise.currentReps) @ \(exercise.currentWeight, specifier: "%.1f") lbs")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .padding(.horizontal)
    }
}

#Preview() {
    ExerciseCardView(exercise: Exercise(name: "Example Exercise", sets: 5, minReps: 4, maxReps: 6, warmupSets: 4, progressHistory: []))

}
