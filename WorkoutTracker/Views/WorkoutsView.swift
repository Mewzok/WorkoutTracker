//
//  WorkoutsView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//  Main workout list page

import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @State private var newWorkout: Workout? = nil
    
    @Environment(\.modelContext) private var context
    @Query private var workouts: [Workout]
    
    @State private var isPresentingAddWorkout = false
    
    // deletion
    @State private var workoutToDelete: Workout? = nil
    @State private var showingDeleteAlert = false
    
    // array of day orders for sorting
    let daysOrder = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    // sort workouts
    var sortedWorkouts: [Workout] {
        workouts.sorted { w1, w2 in
            let index1 = daysOrder.firstIndex(of: w1.day ?? "") ?? Int.max
            let index2 = daysOrder.firstIndex(of: w2.day ?? "") ?? Int.max
            return index1 < index2
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if workouts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "dumbbell")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No workouts yet.")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Button("Add Workout") {
                            addButtonActions()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(sortedWorkouts) { workout in
                            NavigationLink(destination: AddWorkoutView(workout: workout, isModal: false)) {
                                WorkoutCardView(workout: workout)
                            }
                            .listRowBackground(workout.theme.mainColor)
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                workoutToDelete = sortedWorkouts[index]
                                showingDeleteAlert = true
                            }
                        }
                    }
                    .alert("Delete Workout?", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            if let workout = workoutToDelete {
                                context.delete(workout)
                                try? context.save()
                                workoutToDelete = nil
                            }
                        }
                        Button("Cancel", role: .cancel) {
                            workoutToDelete = nil
                        }
                    } message: {
                        Text("Are you sure you want to delete this workout? This action cannot be undone.")
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addButtonActions()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(item: $newWorkout, onDismiss: {
            newWorkout = nil
        }) { workout in
            AddWorkoutView(workout: workout, isModal: true)
                .environment(\.modelContext, context)
        }
        .onAppear {
            print("Workouts loaded:", workouts.count)
            for w in workouts {
                print("Loaded workout:", w.name)
            }
        }
    }
    
    func addButtonActions() {
        let workout = Workout(name: "", theme: .sky, exercises: [], day: nil)
        context.insert(workout)
        newWorkout = workout
    }
}

#Preview {
    WorkoutsView()
}
