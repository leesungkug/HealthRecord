//
//  HeathCharacterView.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/15/24.
//

import SwiftUI

struct HeathCharacterView: View {
    @ObservedObject var viewModel: HealthViewModel
    @State var redper: CGFloat = 0
    @State var blueper: CGFloat = 0
    @State var rectangleHeight: CGFloat = 0
    @State var isAnalyze: Bool = false
    @State var isChest: Bool = false
    @State var isBack: Bool = false
    @State var isShoulder: Bool = false
    @State var isLeg: Bool = false
    @State var isAbdomen: Bool = false
    @State var isArm: Bool = false

    var body: some View {
        if !isAnalyze{
            HomeCharacter
        }
        else{
            AnalyzeCharacter
        }
    }
    
    private var HomeCharacter: some View{
        ZStack(alignment: .bottom){
            if redper == 100 && blueper == 100{
                Rectangle()
                    .frame(width: 120, height: rectangleHeight)
                    .foregroundStyle(LinearGradient(colors: [.red , .yellow, .green], startPoint: .top, endPoint: .bottom))
                    .padding(.bottom, 10)
                    .animation(.easeInOut(duration: 1), value: rectangleHeight)
                    .onAppear {
                        rectangleHeight = 100
                    }
            }else{
                Rectangle()
                    .frame(width: 120, height: redper)
                    .foregroundStyle(.red.opacity(0.5))
                    .padding(.bottom, 10)
                    .animation(.easeInOut(duration: 1), value: redper)
                
                Rectangle()
                    .frame(width: 120, height: blueper)
                    .foregroundStyle(.blue.opacity(0.2))
                    .padding(.bottom, 10)
                    .animation(.easeInOut(duration: 1), value: blueper)
            }
            
            Image(viewModel.workouts.isEmpty ? "NoHealth" : "HealthCharacter")
        }
        .frame(width: 160, height: 150)
        .background(Color("CharBack"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onChange(of: viewModel.anaerobicTime, { oldValue, newValue in
            updateRedPer()
        })
        .onChange(of: viewModel.goalAnaerobic, { oldValue, newValue in
            updateRedPer()
        })
        .onChange(of: viewModel.cardioTime, { oldValue, newValue in
            updateBluePer()

        })
        .onChange(of: viewModel.goalCardio, { oldValue, newValue in
            updateBluePer()
        })
    }
    
    private var AnalyzeCharacter: some View{
        ZStack(alignment: .bottom){
            if isChest{
                Image("chestFill")
                    .padding(.bottom, 58)
            }
            if isBack{
                Image("chestFill")
                    .padding(.bottom, 58)
            }
            if isShoulder{
                Image("shoulderFill")
                    .padding(.bottom, 80)
            }
            if isArm{
                Image("armFill")
                    .padding(.bottom, 53)
            }
            if isAbdomen{
                Image("abdomenFill")
                    .padding(.bottom, 40)
            }
            if isLeg{
                Image("legFill")
                    .padding(.bottom, 21)
            }
            Image("AnalyzeCharacter")
        }
        .frame(width: 160, height: 150)
        .background(Color("CharBack"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onAppear(perform: {
            let newValue = viewModel.fetchPartWorkout()
            isChest = newValue.contains(.chest)
            isBack = newValue.contains(.back)
            isShoulder = newValue.contains(.shoulder)
            isLeg = newValue.contains(.leg)
            isAbdomen = newValue.contains(.abdomen)
            isArm = newValue.contains(.arm)
        })
        .onChange(of: viewModel.workouts, { old, new in
            let newValue = viewModel.fetchPartWorkout()
            isChest = newValue.contains(.chest)
            isBack = newValue.contains(.back)
            isShoulder = newValue.contains(.shoulder)
            isLeg = newValue.contains(.leg)
            isAbdomen = newValue.contains(.abdomen)
            isArm = newValue.contains(.arm)
        })
    }
    
    func updateRedPer(){
        if viewModel.goalAnaerobic > 0 {
            redper = CGFloat(viewModel.anaerobicTime) / CGFloat(viewModel.goalAnaerobic) * 100
            if redper >= 100{
                redper = 100
            }
        }
    }
    
    func updateBluePer(){
        if viewModel.goalCardio > 0 {
            blueper = CGFloat(viewModel.cardioTime) / CGFloat(viewModel.goalCardio) * 100
            if blueper >= 100{
                blueper = 100
            }
        }
    }
    
}

//#Preview {
//    HeathCharacterView()
//}
