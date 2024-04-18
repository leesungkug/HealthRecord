//
//  AddWorkoutView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/18/24.
//

import SwiftUI
import HealthKit

struct AddWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: WorkoutDataViewModel

    var body: some View {
        NavigationView {
            Form {
                Picker("Activity Type", selection: $viewModel.selectedActivityType) {
                    ForEach(HKWorkoutActivityType.allCases, id: \.self) { type in
                        Text(type.name).tag(type)
                    }
                }
                .pickerStyle(WheelPickerStyle())

                TextField("Energy Burned (kcal)", text: $viewModel.energyBurned)
                    .keyboardType(.decimalPad)

                TextField("Distance (meters)", text: $viewModel.distance)
                    .keyboardType(.decimalPad)

                DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .dateAndTime)
                DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .dateAndTime)
            }
            .navigationBarTitle("Add Workout", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.saveWorkout { success, error in
                    if success {
                        print("Workout saved successfully!")
                    } else if let error = error {
                        print("Error saving workout: \(error.localizedDescription)")
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

#Preview {
    AddWorkoutView()
}
