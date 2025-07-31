//
//  AddWorkoutView.swift
//  WorkoutTracker
//
//  Created by Student on 7/31/25.
//

import SwiftUI
import ThemeKit

struct AddWorkoutView: View {
    @State private var name = ""
    @State private var theme: Theme = .sky
    @State private var exercises = []
    @State private var day = ""
    
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Form {
            Section(header: Text("Workout details")) {
                // name
                TextField("Workout name", text: $name)
                
                // theme
                ThemePicker(selection: $theme)
                
                // day?
                Picker("Day", selection: $day) {
                    ForEach(["None", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], id: \.self) { day in
                        Text(day).tag(String?.some(day))
                    }
                }
            }
        }
    }
}

#Preview {
    AddWorkoutView()
}
