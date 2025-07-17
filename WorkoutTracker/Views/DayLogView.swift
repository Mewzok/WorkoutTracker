//
//  DayLogView.swift
//  WorkoutTracker
//
//  Created by Student on 7/17/25.
//

import SwiftUI

struct DayLogView: View {
    let date: Date
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Log for \(formatted(date))")
                    .font(.title2)
                    .padding(.bottom)
                
                TextEditor(text: $notes)
                    .border(Color.gray.opacity(0.5))
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Day Log")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    DayLogView(date: Date())
}
