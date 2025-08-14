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
    
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    } ()
    
    @State private var groupedHistory: [String: [ProgressEntry]] = [:]
    @State private var sortedHistoryKeys: [String] = []
    
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
             
                ForEach(sortedHistoryKeys, id: \.self) { month in
                    Section(
                        header: Text(month)
                        .font(.title3)
                        .bold()
                        .padding(.vertical, 8)
                    ) {
                            if let entries = groupedHistory[month] {
                                ForEach(entries.indices, id: \.self) { idx in
                                    NavigationLink(destination: DayLogView(entry: $groupedHistory[month]![idx])) {
                                        HStack {
                                            let entry = entries[idx]
                                            HStack {
                                                Text(entry.date.formatter(date: .abbreviate, time: .omitted))
                                                Spacer()
                                                Text("\(entry.weight, specifier: "%.1f") lbs x \(entry.reps) reps")
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            currentWeightString = String(format: "%.2f", exercise.currentWeight)
            currentRepsString = String(exercise.currentReps)
            
            let grouped = Dictionary(grouping: exercise.progressHistory) { entry in
                Self.monthFormatter.string(from: entry.date)
            }
            groupedHistory = grouped
            sortedHistoryKeys = grouped.keys.sorted {
                guard
                    let date1 = Self.monthFormatter.date(from: $0),
                    let date2 = Self.monthFormatter.date(from: $1)
                else {
                    return false
                }
                return date1 > date2
            }
        }
    }
}
 
#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: Exercise(name: "EX 1", sets: 3, minReps: 4, maxReps: 6, warmupSets: 0, progressHistory: []))
    }
}
