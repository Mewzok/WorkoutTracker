//
//  ExerciseCardView.swift
//  WorkoutTracker
//
//  Created by Student on 7/15/25.
//

import SwiftUI

struct ExerciseCardView: View {
    let exercise: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                
            }
        }
    }
}

#Preview {
    ExerciseCardView() {
        let exercise = Exercise.sampleData[0]
        ExerciseCardView(exercise: exercise)
    }
}
