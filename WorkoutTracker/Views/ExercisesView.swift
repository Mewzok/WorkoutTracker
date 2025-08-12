//
//  ExerciseListView.swift
//  WorkoutTracker
//
//  Created by Student on 7/29/25.
//  Main exercise list page

import SwiftUI
import SwiftData

struct ExercisesView: View {
    @State private var newExercise: Exercise? = nil
    
    @Environment(\.modelContext) private var context
    @Query private var exercises: [Exercise]
    
    // deletion
    @State private var exerciseToDelete: Exercise? = nil
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            Group {
                if exercises.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No exercises yet.")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Button("Add Exercise") {
                            addButtonActions()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(exercises) { exercise in
                            NavigationLink(destination: AddExerciseView(exercise: exercise)) {
                                ExerciseCardView(exercise: exercise)
                            }
                            //.listRowBackground(exercise.theme.mainColor)
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                exerciseToDelete = exercises[index]
                                showingDeleteAlert = true
                            }
                        }
                    }
                    .alert("Delete Exercise?", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            if let exercise = exerciseToDelete {
                                context.delete(exercise)
                                try? context.save()
                                exerciseToDelete = nil
                            }
                        }
                        Button("Cancel", role: .cancel) {
                            exerciseToDelete = nil
                        }
                    } message: {
                        Text("Are you sure you want to delete this exercise? This action cannot be undone.")
                    }
                }
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addButtonActions()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(item: $newExercise, onDismiss: {
            newExercise = nil
        }) { exercise in
            AddExerciseView(exercise: exercise)
                .environment(\.modelContext, context)
        }
    }
    
    private func addButtonActions() {
        let exercise = Exercise(name: "", sets: 0, minReps: 0, maxReps: 0, warmupSets: 0, progressHistory: [])
        context.insert(exercise)
        newExercise = exercise
    }
}

#Preview {
    ExercisesView()
}
