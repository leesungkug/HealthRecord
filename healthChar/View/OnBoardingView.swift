//
//  OnBoardingView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/15/24.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var animateGradient = false

    var body: some View {
        VStack{

        }
        .background(Color("Background"))
        .onAppear {
            withAnimation {
                self.animateGradient = true
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
