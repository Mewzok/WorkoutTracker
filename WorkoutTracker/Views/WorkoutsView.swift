//
//  WorkoutsView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct WorkoutsView: View {
    let workouts: [Workout]
    
    var body: some View {
        List(workouts) { workout in
            CardView(workout: workout)
                .listRowBackground(workout.theme.mainColor)
        }
    }
}

#Preview {
    WorkoutsView(workouts: Workout.sampleData)
}
