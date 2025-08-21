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
                    VStack(alignment: .trailing) {
                        Text("reps")
                            .frame(alignment: .leading)
                        Text("Min: \(exercise.minReps) • Max: \(exercise.maxReps)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
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
                        
                        // generate dynamic note
                        let newNote = exercise.updateProgress(newWeight: weight, newReps: reps, on: today, context: context)
                        existingEntry.note += newNote
                        
                        // update values
                        existingEntry.weight = weight
                        existingEntry.reps = reps
                    } else {
                        // create new progress entry while updating weight and reps
                        let newEntry = ProgressEntry(date: Date(), weight: weight, reps: reps)
                        newEntry.note = "Exercise created. Starting at \(String(format: "%g", weight)) lbs, \(String(reps)) reps. "
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

}
 
#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: Exercise(name: "EX 1", sets: 3, minReps: 4, maxReps: 6, warmupSets: 0, progressHistory: []))
    }
}
