//
//  AddExerciseView.swift
//  WorkoutTracker
//
//  Created by Student on 7/29/25.
//  Exercise creation view, seen when adding a new exercise but not modifying an existing one

import SwiftUI

struct AddExerciseView: View {
    @Bindable var exercise: Exercise
    var isModal: Bool = true // determine which presentation style, tells if new or modifying
    
    @State private var setsString: String = ""
    @State private var minRepsString: String = ""
    @State private var maxRepsString: String = ""
    @State private var warmupSetsString: String = ""
    @State private var currentWeightString: String = ""
    @State private var currentRepsString: String = ""
    
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    
    var body: some View {
        NavigationStack {
            Form {
                // name
                Section(header: Text("Exercise Details")) {
                    TextField("Exercise Name", text: $exercise.name)
                    
                    // sets
                    HStack {
                        TextField("Number of sets", text: $setsString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .onChange(of: setsString) {
                                setsString = setsString.filter { "0123456789".contains($0) }
                            }
                        Text("sets")
                            .frame(alignment: .leading)
                    }
                    
                    // reps
                    HStack {
                        TextField("Minimum number of reps", text: $minRepsString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .onChange(of: minRepsString) {
                                minRepsString = minRepsString.filter { "0123456789".contains($0) }
                            }
                        Text("min reps")
                            .frame(alignment: .leading)
                    }
                    HStack {
                        TextField("Maximum number of reps", text: $maxRepsString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .onChange(of: maxRepsString) {
                                maxRepsString = maxRepsString.filter { "0123456789".contains($0) }
                            }
                        Text("max reps")
                            .frame(alignment: .leading)
                    }
                    // warmup?
                    HStack {
                        TextField("Warmup sets", text: $warmupSetsString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .onChange(of: warmupSetsString) {
                                warmupSetsString = warmupSetsString.filter { "0123456789".contains($0) }
                            }
                        Text("warmup sets")
                            .frame(alignment: .leading)
                    }
                }
                
                Section(header: Text("Your Stats (optional)")) {
                    // current weight
                    HStack {
                        TextField("Current weight", text: $currentWeightString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.leading)
                            .onChange(of: currentWeightString) {
                                currentWeightString = currentWeightString.filter { ".0123456789".contains($0) }
                            }
                        Text("lbs")
                            .frame(alignment: .leading)
                    }
                    
                    // current reps
                    HStack {
                        TextField("Current reps", text: $currentRepsString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .onChange(of: currentRepsString) {
                                currentRepsString = currentRepsString.filter { "0123456789".contains($0) }
                            }
                        Text("reps")
                            .frame(alignment: .leading)
                    }
                }
            }
            .navigationTitle(isModal ? "Add Exercise" : "View Exercise")
            .toolbar {
                if isModal {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            context.delete(exercise)
                            try? context.save()
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if exercise.name.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAlert = true
                        } else {
                            do {
                                try saveExercise()
                            } catch {
                                print("Failed to save exercise:", error.localizedDescription)
                            }
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert("Exercise name is required.", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a name for your exercise before saving.")
        }
        .onAppear {
            if isModal == false {
                setsString = String(exercise.sets)
                minRepsString = String(exercise.minReps)
                maxRepsString = String(exercise.maxReps)
                warmupSetsString = String(exercise.warmupSets)
                
                currentWeightString = String(format: "%g", exercise.currentWeight)
                currentRepsString = String(exercise.currentReps)
            }
        }
    }
    
    
    private func saveExercise() throws {
        // convert user input strings into ints and doubles for saving
        let setsInt = Int(setsString.trimmingCharacters(in: .whitespaces)) ?? 0
        let minRepsInt = Int(minRepsString.trimmingCharacters(in: .whitespaces)) ?? 0
        let maxRepsInt = Int(maxRepsString.trimmingCharacters(in: .whitespaces)) ?? 0
        let warmupSetsInt = Int(warmupSetsString.trimmingCharacters(in: .whitespaces)) ?? 0
        
        var progressHistory: [ProgressEntry] = []
        
        if currentWeightString != "" || currentRepsString != "" {
            let currentWeightDouble = Double(currentWeightString.trimmingCharacters(in: .whitespaces)) ?? 0.0
            let currentRepsInt = Int(currentRepsString.trimmingCharacters(in: .whitespaces)) ?? 0
            
            // create progress entry
            let progress = ProgressEntry(date: .now, weight: currentWeightDouble, reps: currentRepsInt)
            
            // create initial creation note
            progress.note = "Exercise created. Weight: \(Double(currentWeightDouble)) lbs, Reps: \(Int(currentRepsInt))"
            
            progressHistory = [progress]
        }
        
        // modify exercise with new values
        exercise.sets = setsInt
        exercise.minReps = minRepsInt
        exercise.maxReps = maxRepsInt
        exercise.warmupSets = warmupSetsInt
        exercise.progressHistory = progressHistory
        
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
