//
//  AddWorkoutView.swift
//  WorkoutTracker
//
//  Created by Student on 7/31/25.
//

import SwiftUI
import ThemeKit

struct AddWorkoutView: View {
    @Bindable var workout: Workout
    var isModal: Bool = true // determine which presentation style, tells if new or modifying
    
    @State private var showAlert = false
    @State private var isPresentingSelectView = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Workout details")) {
                    // name
                    TextField("Workout name", text: $workout.name)
                    
                    // theme
                    ThemePicker(selection: $workout.theme)
                    
                    // day?
                    Picker("Day", selection: $workout.day) {
                        Text("None").tag(nil as String?)
                        ForEach(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], id: \.self) { day in
                            Text(day).tag(Optional(day))
                        }
                    }
                }
                
                Section(header: Text("Exercises")) {
                    Button("Select Exercises") {
                        isPresentingSelectView = true
                    }
                    
                    // show currently selected exercises
                    if workout.exercises.isEmpty {
                        Text("This workout contains no exercises.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(workout.exercises) { exercise in
                            Text(exercise.name)
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentingSelectView) {
                NavigationStack {
                    ExerciseSelectionView(workout: workout)
                        .navigationTitle("Select Exercises")
                }
            }
            .navigationTitle(isModal ? "Add Workout" : "View Workout")
            .toolbar {
                if isModal {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            context.delete(workout)
                            try? context.save()
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if workout.name.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAlert = true
                        } else {
                            do {
                                try context.save()
                            } catch {
                                print("Failed to save workout:", error.localizedDescription)
                            }
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert("Workout name required.", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a name for your workout before saving.")
        }
    }
}

#Preview {
    AddWorkoutView(workout: Workout(name: "Ex Workout", theme: .sky, exercises: [], day: nil))
}
