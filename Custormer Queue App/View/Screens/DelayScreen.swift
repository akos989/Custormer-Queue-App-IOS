//
//  DelayScreen.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import SwiftUI

struct DelayScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WaitingScreen.ViewModel
    @State private var delayTime = 10
    
    var body: some View {
        Form {
            Section {
                Picker("Delay time is", selection: $delayTime) {
                    ForEach(Array(stride(from: 5, to: 100, by: 5)), id: \.self) {
                        Text("\($0) minutes")
                    }
                }
            } header: {
                Text("How many minutes do you want to delay your call? It may add more time to your ticket than requested!")
            }
            Button("Delay call") {
                viewModel.delayCallWith(minutes: delayTime)
                dismiss()
            }
        }
    }
}
