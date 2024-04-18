//
//  SetGoalView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/15/24.
//

import SwiftUI

struct SetGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HealthViewModel
    @State var goalAnaerobic: Int = 0
    @State var goalCardio: Int = 0
    
    var body: some View {
        VStack{
            Text("일일 웨이트 목표")
                .font(.system(size: 35, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 178)
            GoalView(viewModel: viewModel, type: .Anaerobic, goal: $goalAnaerobic)
            
            Text("일일 유산소 목표")
                .font(.system(size: 35, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top)
            GoalView(viewModel: viewModel, type: .Cardio, goal: $goalCardio)
            Spacer()

            Button(action: {
                viewModel.setGoal(Anaerobic: goalAnaerobic, Cardio: goalCardio)
                dismiss()
            }, label: {
                HStack{
                    Spacer()
                    Text("목표 변경하기")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .frame(height: 45)
                .background(Color("ContentBackground"))
                .cornerRadius(10)
                .padding()
            })
 

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView(backName: "Home"))
        .background(Color("Background"))
        .onAppear(perform: {
            goalAnaerobic = viewModel.goalAnaerobic
            goalCardio = viewModel.goalCardio

        })
    }
}

struct GoalView: View {
    @ObservedObject var viewModel: HealthViewModel
    var type: Workout
    @Binding var goal: Int

    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                goal -= 10
            }, label: {
                Image(type == .Anaerobic ? "red_minus.circle.fill" : "blue_minus.circle.fill")
                    .frame(width: 40, height: 40)
            })
            Text("\(goal)분")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, 42)
                .padding(.trailing, 42)
            Button(action: {
                goal += 10

            }, label: {
                Image(type == .Anaerobic ? "red_plus.circle.fill" : "blue_plus.circle.fill")
                    .frame(width: 40, height: 40)
            })
            Spacer()
        }
    }
        
}


#Preview {

    SetGoalView(viewModel: HealthViewModel())
}
