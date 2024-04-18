//
//  healthCharApp.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/5/24.
//

import SwiftUI

@main
struct healthCharApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = HealthViewModel()
//    @State var isChang: Bool = false
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        UITextView.appearance().backgroundColor = .clear
        HealthKitManager.shared.requestAuthorization { success in
            //error handler
//            print("\(success)")
        }
    }

    var body: some Scene {
        WindowGroup {
//            if !isChang{
//                OnBoardingView()
//                    .onAppear{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            isChang = true
//                            }
//                    }
//            }
//            else{
                HomeView(viewModel: viewModel)
                    .environmentObject(viewModel)
//            }
        }
        .onChange(of: scenePhase) { old, new in
            if new == .background {
                viewModel.saveCustomWorkouts()
            }
        }
    }
}
