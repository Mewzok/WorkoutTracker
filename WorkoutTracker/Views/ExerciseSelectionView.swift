//
//  ExerciseSelectionView.swift
//  WorkoutTracker
//
//  Created by Student on 7/31/25.
//  View shown when selecting exercises to add to a workout

import SwiftUI
import SwiftData

struct ExerciseSelectionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var exercises: [Exercise]
    
    @Bindable var workout: Workout
    
    @State private var selectedExercises: Set<Exercise> = []
    
    var body: some View {
        NavigationStack {
            if exercises.isEmpty {
                Text("No saved exercises.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
            } else {
                List {
                    ForEach(exercises) { exercise in
                        VStack(alignment: .leading) {
                            ExerciseListRowView(exercise: exercise,
                                                trailingButtons: AnyView(
                                                    Button(action: {
                                                        if workout.exercises.contains(exercise) {
                                                            workout.exercises.removeAll { $0 == exercise }
                                                        } else {
                                                            workout.exercises.append(exercise)
                                                        }
                                                    }) {
                                                        Image(systemName: workout.exercises.contains(exercise) ? "checkmark" : "plus")
                                                    }
                                                        .buttonStyle(.bordered)
                                                ))
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Confirm") {
                    workout.exercises.append(contentsOf: selectedExercises)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    let previewWorkout = Workout(name: "Preview Workout", theme: .seafoam, exercises: [], day: nil)
    NavigationStack {
        ExerciseSelectionView(workout: previewWorkout)
    }
}
