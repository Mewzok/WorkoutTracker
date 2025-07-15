//
//  ExercisesView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct ExercisesView: View {
    let workout: Workout
    
    var body: some View {
        List {
            Section(header: Text("Workout Info")) {
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExercisesView(workout: Workout.sampleData[0])
    }
}
