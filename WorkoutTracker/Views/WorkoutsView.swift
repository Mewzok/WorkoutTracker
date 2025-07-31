//
//  WorkoutsView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//  Main workout list page

import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Environment(\.modelContext) private var context
    @Query private var workouts: [Workout]
    
    @State private var isPresentingAddWorkout = false
    
    var body: some View {
        NavigationStack {
            if workouts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "dumbbell")
                        .font(.system(size: 64))
                        .foregroundColor(.gray)
                    Text("No workouts yet.")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Button("Add Workout") {
                        isPresentingAddWorkout = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(workouts) { workout in
                    NavigationLink(destination: AddWorkoutView()) {
                        WorkoutCardView(workout: workout)
                    }
                    .listRowBackground(workout.theme.mainColor)
                }
            }
        }
        .navigationTitle("Workouts")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresentingAddWorkout = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingAddWorkout) {
            AddWorkoutView()
        }
    }
}

#Preview {
    WorkoutsView()
}
