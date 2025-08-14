//
//  WorkoutDetailView.swift
//  WorkoutTracker
//
//  Created by Student on 8/12/25.
//  This shows a user's already created workout's details, readonly

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @State private var showingEditWorkout = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // list of exercises
                if workout.exercises.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No exercises in this workout.")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    List(workout.exercises) { exercise in
                        NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                            ExerciseCardView(exercise: exercise)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                
                // progress calendar placeholder
                /*ProgressCalendarView(progressHistory: workout.progressHistory)
                    .frame(height: 300) */
            }
            .navigationTitle(workout.name)
            .toolbar {
                Button("Edit") {
                    showingEditWorkout = true
                }
            }
            .sheet(isPresented: $showingEditWorkout) {
                AddWorkoutView(workout: workout)
            }
        }
    }
}

#Preview {
    WorkoutDetailView(workout: Workout(name: "Ex Workout", theme: .sky, exercises: [], day: nil))
}
