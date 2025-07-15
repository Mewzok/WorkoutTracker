//
//  AddProgressEntryView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct AddProgressEntryView: View {
    @Binding var exercise: Exercise
    @Environment(\.dismiss) var dismiss
    
    @State private var weight: Double = 0
    @State private var reps: Int = 0
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Weight")
                    Spacer()
                    TextField(String(exercise.currentWeight), value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("lbs")
                }
                HStack {
                    Text("Reps")
                    Spacer()
                    TextField(String(exercise.currentReps), value: $reps, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("reps")
                }
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .onAppear {
                weight = exercise.currentWeight
                reps = exercise.currentReps
            }
            .navigationTitle("Update Progress")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = ProgressEntry(date: date, weight: weight, reps: reps)
                        exercise.progressHistory.append(entry)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var exercise = Exercise.sampleData[0]
    AddProgressEntryView(exercise: $exercise)
}
