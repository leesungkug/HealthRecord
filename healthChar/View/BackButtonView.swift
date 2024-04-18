//
//  BackButtonView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/18/24.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: HealthViewModel

    var backName: String
    
    var body: some View {
        Button{
            viewModel.currentDay = Date()
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image("backButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text(backName)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("Workout"))
            }
        }
    }
}
