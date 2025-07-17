//
//  DayLogView.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import SwiftUI

struct DayLogView: View {
    let date: Date
    @Binding var selectedDate: Date?
    @State private var noteText: String = ""
    @EnvironmentObject var logStorage: LogStorage
    
    var body: some View {
        NavigationView {
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
                        if let date = selectedDate {
                            noteText = logStorage.getLog(for: date)?.note ?? ""
                        }
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("Save") {
                        if let date = selectedDate {
                            logStorage.updateLog(for: date, with: noteText)
                        }
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
            noteText = logStorage.getLog(for: date)?.note ?? ""
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
        DayLogView(
    date: selectedDate ?? Date(),
        selectedDate: $selectedDate
    )
        .environmentObject(LogStorage())
    }
}
