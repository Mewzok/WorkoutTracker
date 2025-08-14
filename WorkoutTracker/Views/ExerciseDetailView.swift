//
//  ExerciseDetailView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//  Exercise modification/progress update view, seen when selecting an already existing exercise

import SwiftUI

struct ExerciseDetailView: View {
    @Bindable var exercise: Exercise
    @State private var showingCalendar = false
    
    @State private var currentWeightString: String = ""
    @State private var currentRepsString: String = ""
    
    @Environment(\.modelContext) private var context
    
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
                Button("Update Progress") {
                    
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
                    CalendarGridView()
                }
                ForEach(exercise.progressHistory, id: \.self) { entry in
                    NavigationLink(destination: DayLogView(date: entry.date)) {
                        HStack {
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                 Spacer()
                                 Text("\(entry.weight, specifier: "%.1f") lbs x \(entry.reps) reps")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .onAppear {
            currentWeightString = String(format: "%.2f", exercise.currentWeight)
            currentRepsString = String(exercise.currentReps)
        }
    }
}
 
#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: Exercise(name: "EX 1", sets: 3, minReps: 4, maxReps: 6, warmupSets: 0, progressHistory: []))
    }
}
