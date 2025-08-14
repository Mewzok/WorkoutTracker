//
//  DayLogView.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import SwiftUI
import SwiftData

struct DayLogView: View {
    let date: Date
    var didAddLog: ((Bool) -> Void)? = nil
    
    @State private var noteText: String = ""
    @State private var todayLog: DailyLog?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var allLogs: [DailyLog]
    
    var body: some View {
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
                        var added = false
                        if let existing = todayLog {
                            existing.note = noteText
                        } else {
                            let newLog = DailyLog(date: date)
                            newLog.appendNote(newNote: noteText)
                            modelContext.insert(newLog)
                            added = true
                            
                            // change highlighted dates
                            didAddLog?(true)
                            
                        }
                        
                        do {
                            try modelContext.save()
                            didAddLog?(added)
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
        }
        .onAppear {
            if let existing = allLogs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                todayLog = existing
                noteText = existing.note
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
        DayLogView(date: Date())
    }
}
