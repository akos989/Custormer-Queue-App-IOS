//
//  ContentView.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 23..
//

import CodeScanner
import SwiftUI

struct WelcomeScreen: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Customer Queue App")
                .font(.largeTitle)
            Spacer()
            Spacer()
            Button {
                viewModel.isShowingScanner = true
            } label: {
                Label("Scan QR code", systemImage: "qrcode.viewfinder")
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.isShowingScanner) {
            CodeScannerView(codeTypes: [.qr]) {
                viewModel.handleScan(result: $0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
