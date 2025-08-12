//
//  WorkoutCardView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//  Design of individual workout cards

import SwiftUI

struct WorkoutCardView: View {
    let workout: Workout
    
    // convert days to abbreviations
    private var dayAbbreviation: String {
        guard let day = workout.day else { return "None" }
        return String(day.prefix(3)).uppercased()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(workout.name)
                    .font(.headline)
                    .lineLimit(1) // prevent more than 1 line
                    .truncationMode(.tail) // adds "..." if too long
                    .layoutPriority(1) // give workout name priority
                
                Spacer()
                
                // show day
                Text(dayAbbreviation)
                    .font(.subheadline)
                    .foregroundColor(workout.theme.accentColor.opacity(0.8))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(workout.theme.accentColor.opacity(0.15)))
                    .fixedSize()
                
                // show exercise count
                Text("\(workout.exercises.count) exercises")
                    .font(.caption)
                    .padding(8)
                    .background(Circle().fill(workout.theme.accentColor.opacity(0.2)))
                    .fixedSize()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(workout.theme.mainColor)
        .foregroundColor(workout.theme.accentColor)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 60)) {
    WorkoutCardView(workout: Workout(name: "Ex Workout", theme: .sky, exercises: [], day: "Wednesday"))
}
