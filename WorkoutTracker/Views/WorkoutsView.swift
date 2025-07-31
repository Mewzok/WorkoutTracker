//
//  WorkoutsView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//  Main workout list page

import SwiftUI

struct WorkoutsView: View {
    let workouts: [Workout]
    
    var body: some View {
        NavigationStack {
            List(workouts) { workout in
                NavigationLink(destination: AddWorkoutView()) {
                    WorkoutCardView(workout: workout)
                }
                .listRowBackground(workout.theme.mainColor)
            }
            .navigationTitle("Workouts")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    WorkoutsView(workouts: Workout.sampleData)
}
