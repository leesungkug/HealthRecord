//
//  WorkoutViewModel.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/18/24.
//
import Foundation
import HealthKit

class WorkoutDataViewModel: ObservableObject {
    @Published var selectedActivityType = HKWorkoutActivityType.running
    @Published var energyBurned = ""
    @Published var distance = ""
    @Published var startTime = Date().addingTimeInterval(-3600)
    @Published var endTime = Date()

    var healthStore = HealthKitManager.shared.healthStore
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKWorkoutBuilder?
    
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = selectedActivityType
        configuration.locationType = .outdoor

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()

            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            workoutSession?.startActivity(with: startTime)
            workoutBuilder?.beginCollection(withStart: startTime) { success, error in
            }
        } catch {
            print("Unable to create workout session: \(error.localizedDescription)")
        }
    }

    func saveWorkout() {
        guard let builder = workoutBuilder, let session = workoutSession else { return }

        builder.endCollection(withEnd: endTime) { success, error in
            guard success else {
                print("Failed to end the collection: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            session.endActivity(with: endTime)
            builder.finishWorkout { workout, error in
                if let workout = workout {
                    print("Workout saved: \(workout)")
                } else if let error = error {
                    print("Error saving workout: \(error.localizedDescription)")
                }
            }
        }
    }
}
