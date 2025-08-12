//
//  ExerciseListView.swift
//  WorkoutTracker
//
//  Created by Student on 7/29/25.
//  Main exercise list page

import SwiftUI
import SwiftData

struct ExercisesView: View {
    @Environment(\.modelContext) private var context
    @Query private var exercises: [Exercise]
    @State private var showingAddExercise = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exercises) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        VStack(alignment: .leading) {
                            ExerciseListRowView(exercise: exercise, trailingButtons: nil)
                            Text("Weight: \(exercise.currentWeight, specifier: "%.1f") lbs | Reps: \(exercise.currentReps) | Sets: \(exercise.sets)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteExercises)
            }
            .navigationTitle("My Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddExercise = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                NavigationStack {
                    AddExerciseView()
                }
            }
        }
    }
    
    private func deleteExercises(at offsets: IndexSet) {
        for index in offsets {
            context.delete(exercises[index])
        }
        try? context.save()
    }
}

#Preview {
    ExercisesView()
}
