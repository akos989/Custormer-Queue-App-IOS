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
    @StateObject var errorHandlerService = ErrorHandlerService.shared
    
    var body: some View {
        VStack {
            Button("Add") {
                let randomNumber = Int.random(in: 1...50)
                ErrorHandlerService.shared.errorMessages.append("Error with number #\(randomNumber)")
            }
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
        .progressViewOverlay(showingProgess: viewModel.isLoading, title: "Finding services for customer serivce")
        .sheet(isPresented: $viewModel.isShowingScanner) {
            CodeScannerView(codeTypes: [.qr]) {
                viewModel.handleScan(result: $0)
            }
        }
        .errorHandler(errorMessages: $errorHandlerService.errorMessages)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
