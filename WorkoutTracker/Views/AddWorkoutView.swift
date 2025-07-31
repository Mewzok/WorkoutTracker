//
//  AddWorkoutView.swift
//  WorkoutTracker
//
//  Created by Student on 7/31/25.
//

import SwiftUI
import ThemeKit

struct AddWorkoutView: View {
    @State private var workout = Workout(name: "", theme: .sky, exercises: [], day: nil)
    
    @State private var showAlert = false
    @State private var isPresentingSelectView = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
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
    }
}

#Preview {
    AddWorkoutView()
}
