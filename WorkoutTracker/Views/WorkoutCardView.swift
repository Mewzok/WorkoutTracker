//
//  WorkoutCardView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct WorkoutCardView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(workout.theme.accentColor)
                    .frame(width: 10, height: 10)
                Text(workout.name)
                    .font(.headline)
                Spacer()
                Text("\(workout.exercises.count) exercises")
                    .font(.caption)
                    .padding(8)
                    .background(Circle().fill(workout.theme.accentColor.opacity(0.2)))
                //Image(systemName: "chevron.right")
                  //  .foregroundColor(.gray)
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
    let workout = Workout.sampleData[0]
    WorkoutCardView(workout: workout)
}
