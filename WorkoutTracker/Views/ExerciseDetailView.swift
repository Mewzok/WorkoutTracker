//
//  ExerciseDetailView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//  Exercise modification/progress update view, seen when selecting an already existing exercise

import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    @Bindable var exercise: Exercise
    @State private var showingCalendar = false
    
    @State private var currentWeightString: String = ""
    @State private var currentRepsString: String = ""
    
    @Environment(\.modelContext) private var context
    @Query var allLogs: [DailyLog]
    
    var body: some View {
        Form {
            Section(header: Text("Exercise Info")) {
                // name
                TextField("Exercise name", text: $exercise.name)
                
                // current weight
                HStack {
                    TextField("Current weight",  text: $currentWeightString)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.leading)
                        .onChange(of: currentWeightString) {
                            currentWeightString = currentWeightString.filter {
                                ".0123456789".contains($0) }
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
                            currentRepsString = currentRepsString.filter {
                                "0123456789".contains($0) }
                        }
                    Text("reps")
                        .frame(alignment: .leading)
                }
                
                // progress entry
                Button("Update Progress") {
                    // convert strings
                    guard let weight = Double(currentWeightString),
                          let reps = Int(currentRepsString)
                    else {
                        return // maybe show alert later
                    }
                    
                    // check for existing entry
                    let today = Calendar.current.startOfDay(for: Date())
                    if let existingEntry = exercise.progressHistory.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today)}) {
                        
                        // assign old weight and reps
                        let oldWeight = exercise.currentWeight
                        let oldReps = exercise.currentReps
                        
                        // update values
                        existingEntry.weight = weight
                        existingEntry.reps = reps
                        
                        
                        // generate dynamic note
                        let newNote = logNote(originalWeight: oldWeight, originalReps: oldReps, weight: weight, reps: reps)
                        existingEntry.note += existingEntry.note.isEmpty ? newNote : "\n\(newNote)"
                    } else {
                        // create new progress entry while updating weight and reps
                        let newEntry = ProgressEntry(date: Date(), weight: weight, reps: reps)
                        newEntry.note = "Weight: \(String(format: "%g", weight)) lbs, Reps: \(reps)"
                        exercise.progressHistory.append(newEntry)
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed to save exercise progress: \(error)")
                    }
                }
            }
            
            // progress history section
            Section(header: Text("Progress History")) {
                Button() {
                    showingCalendar = true
                } label: {
                    Label("Show Calendar", systemImage: "calendar")
                }
                .padding(.vertical, 4)
                .sheet(isPresented: $showingCalendar) {
                    CalendarGridView(exercise: exercise)
                }
                ForEach(exercise.progressHistory.sorted(by: { $0.date > $1.date}), id: \.self) { entry in
                    NavigationLink(destination: DayLogView(exercise: exercise, date: entry.date)) {
                        HStack {
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                 Spacer()
                                 Text("\(entry.weight, specifier: "%g") lbs x \(entry.reps) reps")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .onAppear {
            currentWeightString = String(format: "%g", exercise.currentWeight)
            currentRepsString = String(exercise.currentReps)
        }
    }
    
    // generate dynamic note text
    private func logNote(originalWeight: Double, originalReps: Int, weight: Double, reps: Int) -> String {
        var changes: [String] = []
        
        // check weight
        if weight != originalWeight {
            if weight > originalWeight {
                changes.append("Weight increased from \(String(format: "%g", originalWeight)) lbs to \(String(format: "%g", weight))")
            } else {
                changes.append("Weight decreased to \(String(format: "%g", weight)) lbs from \(String(format: "%g", originalWeight))")
            }
        }
        
        // check reps
        if reps != originalReps {
            if reps > originalReps {
                changes.append("Reps increased from \(Int(originalReps)) to \(Int(reps))")
            } else {
                changes.append("Reps decreased to \(Int(reps)) from \(Int(originalReps))")
            }
        }
        
        return changes.joined(separator: " ")
    }
}
 
#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: Exercise(name: "EX 1", sets: 3, minReps: 4, maxReps: 6, warmupSets: 0, progressHistory: []))
    }
}
