//
//  AddExerciseView.swift
//  WorkoutTracker
//
//  Created by Student on 7/29/25.
//  Exercise creation view, seen when adding a new exercise but not modifying an existing one

import SwiftUI

struct AddExerciseView: View {
    @Bindable var exercise: Exercise
    
    @State private var exerciseName = ""
    @State private var sets = ""
    @State private var minReps = ""
    @State private var maxReps = ""
    @State private var warmupSets = ""
    
    @State private var currentWeight = ""
    @State private var currentReps = ""
    
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    
    var body: some View {
        Form {
            // name
            Section(header: Text("Exercise Details")) {
                TextField("Exercise Name", text: $exerciseName)
                
                // sets
                HStack {
                    TextField("Number of sets", text: $sets)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .onChange(of: sets) {
                            sets = sets.filter { "0123456789".contains($0) }
                        }
                    Text("sets")
                        .frame(alignment: .leading)
                }
                
                // reps
                HStack {
                    TextField("Minimum number of reps", text: $minReps)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .onChange(of: minReps) {
                            minReps = minReps.filter { "0123456789".contains($0) }
                        }
                    Text("reps")
                        .frame(alignment: .leading)
                }
                HStack {
                    TextField("Maximum number of reps", text: $maxReps)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .onChange(of: maxReps) {
                            maxReps = maxReps.filter { "0123456789".contains($0) }
                        }
                    Text("reps")
                        .frame(alignment: .leading)
                }
                // warmup?
                HStack {
                    TextField("Warmup sets", text: $warmupSets)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .onChange(of: warmupSets) {
                            warmupSets = warmupSets.filter { "0123456789".contains($0) }
                        }
                    Text("sets")
                        .frame(alignment: .leading)
                }
            }
            Section(header: Text("Your Stats (optional)")) {
                // current weight
                HStack {
                    TextField("Current weight", text: $currentWeight)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.leading)
                        .onChange(of: currentWeight) {
                            currentWeight = currentWeight.filter { ".0123456789".contains($0) }
                        }
                    Text("lbs")
                        .frame(alignment: .leading)
                }
                
                // current reps
                HStack {
                    TextField("Current reps", text: $currentReps)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .onChange(of: currentReps) {
                            currentReps = currentReps.filter { "0123456789".contains($0) }
                        }
                    Text("reps")
                        .frame(alignment: .leading)
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
                Button("Done") {
                    if exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        showAlert = true
                    } else {
                        try? saveExercise()
                        dismiss()
                    }
                }
                .alert("Exercise name is required.", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
    }
    
    
    private func saveExercise() throws {
        // convert user input strings into ints and doubles for saving
        let setsInt = Int(sets) ?? 0
        let minRepsInt = Int(minReps) ?? 0
        let maxRepsInt = Int(maxReps) ?? 0
        let warmupSetsInt = Int(warmupSets) ?? 0
        
        var progressHistory: [ProgressEntry] = []
        
        if currentWeight != "" || currentReps != "" {
            let currentWeightDouble = Double(currentWeight) ?? 0.0
            let currentRepsInt = Int(currentReps) ?? 0
            
            // create progress entry
            let progress = ProgressEntry(date: .now, weight: currentWeightDouble, reps: currentRepsInt)
            progressHistory = [progress]
        }
            
            // create full exercise object
            let exercise = Exercise(name: exerciseName, sets: setsInt, minReps: minRepsInt, maxReps: maxRepsInt, warmupSets: warmupSetsInt, progressHistory: progressHistory)
        
        // save to model context
        context.insert(exercise)
        try? context.save()
    }
}

#Preview {
    NavigationStack {
        AddExerciseView(exercise: Exercise(name: "", sets: 0, minReps: 0, maxReps: 0, warmupSets: 0, progressHistory: []))
    }
}
