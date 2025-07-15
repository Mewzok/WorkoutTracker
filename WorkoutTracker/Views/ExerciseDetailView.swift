//
//  ExerciseDetailView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct ExerciseDetailView: View {
    @State var exercise: Exercise
    @State private var showingAddProgressSheet = false
    
    var body: some View {
        List {
            Section(header: Text("Exercise Info")) {
                HStack {
                    Label("Name", systemImage: "timer")
                    Spacer()
                    Text(exercise.name)
                }
                HStack {
                    Label("Sets", systemImage: "timer")
                    Spacer()
                    Text(String(exercise.sets))
                }
                HStack {
                    Label("Min - Max Reps", systemImage: "timer")
                    Spacer()
                    Text(String(exercise.minReps) + " - " + String(exercise.maxReps))
                }
                HStack {
                    Label("Warmup Sets", systemImage: "timer")
                    Spacer()
                    Text(String(exercise.warmupSets))
                }
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(exercise.theme.name)
                        .padding(4)
                        .foregroundColor(exercise.theme.accentColor)
                        .background(exercise.theme.mainColor)
                        .cornerRadius(4)
                }
            }
            
            Section(header: Text("Your Stats")) {
                HStack {
                    Label("Weight", systemImage: "timer")
                    Spacer()
                    Text(String(exercise.currentWeight))
                }
                HStack {
                    Label("Reps", systemImage: "timer")
                    Spacer()
                    Text(String(exercise.currentReps))
                }
                Button("Update Progress") {
                    showingAddProgressSheet = true
                }
                .sheet(isPresented: $showingAddProgressSheet) {
                    AddProgressEntryView(exercise: $exercise)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: Exercise.sampleData[0])
    }
}
