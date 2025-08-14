//
//  AddProgressEntryView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI
import SwiftData

struct AddProgressEntryView: View {
    @Binding var exercise: Exercise
    @Environment(\.dismiss) var dismiss
    
    @State private var weight: Double = 0
    @State private var originalWeight: Double = 0
    @State private var reps: Int = 0
    @State private var originalReps: Int = 0
    @State private var date = Date()
    
    @Query var allLogs: [DailyLog]
    @State private var todayLog: DailyLog?
    @Environment(\.modelContext) var modelContext
    
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
                originalWeight = exercise.currentWeight
                originalReps = exercise.currentReps
            }
            .navigationTitle("Update Progress")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = ProgressEntry(date: date, weight: weight, reps: reps)
                        exercise.progressHistory.append(entry)
                        
                        // determine changes and create strings for each
                        var changes: [String] = []
                        
                        if weight != originalWeight {
                            if weight > originalWeight {
                                changes.append("Weight increased from \(Int(originalWeight)) lbs to \(Int(weight))")
                            } else {
                                changes.append("Weight decreased to \(Int(originalWeight)) lbs from \(Int(weight))")
                            }
                        }
                        
                        if reps != originalReps {
                            if reps > originalReps {
                                changes.append("Reps increased from \(Int(originalReps)) to \(Int(reps))")
                            } else {
                                changes.append("Reps decreased to \(Int(originalReps)) from \(Int(reps))")
                            }
                        }
                        
                        let summary = changes.joined(separator: " ")
                        
                        autoLog(summary: "\(summary)", for: date)
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
    
    private func autoLog(summary: String, for date: Date) {
        let existingLog = allLogs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date)} )
        
        if let log = existingLog {
            log.note += "\n\(summary)"
        } else {
            let newLog = DailyLog(date: date)
            newLog.appendNote(newNote: summary)
            modelContext.insert(newLog)
        }
    }
}

#Preview {
    @Previewable @State var exercise = Exercise.sampleData[0]
    AddProgressEntryView(exercise: $exercise)
}
