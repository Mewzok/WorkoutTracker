//
//  DayLogView.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import SwiftUI
import SwiftData

struct DayLogView: View {
    @Bindable var exercise: Exercise
    
    let date: Date
    var didAddLog: ((Bool) -> Void)? = nil
    
    @State private var noteText: String = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        var daysEntries: ProgressEntry? {
            exercise.progressHistory.first { Calendar.current.isDate($0.date, inSameDayAs: date)}
        }
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Log for \(formatted(date))")
                    .font(.title2)
                    .padding(.bottom)
                
                TextEditor(text: $noteText)
                    .border(Color.gray.opacity(0.5))
                    .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("Save") {
                        let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if let entry = daysEntries {
                            entry.note = trimmed
                            
                        } else if !trimmed.isEmpty {
                            let newEntry = ProgressEntry(date: date, weight: exercise.currentWeight, reps: exercise.currentReps)
                            newEntry.note = trimmed
                            exercise.progressHistory.append(newEntry)
                            
                        }
                        
                            // change highlighted dates
                        didAddLog?(trimmed.isEmpty == false)
                        
                        do {
                            try modelContext.save()
                        } catch {
                            print("Error saving log: \(error)")
                        }
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .padding()
            .navigationTitle("Day Log")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                noteText = daysEntries?.note ?? ""
            }
        }
    }
    
    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    @State private var selectedDate: Date? = Date()
    
    var body: some View {
        DayLogView(exercise: Exercise(name: "", sets: 0, minReps: 0, maxReps: 0, warmupSets: 0, progressHistory: []), date: Date())
    }
}
