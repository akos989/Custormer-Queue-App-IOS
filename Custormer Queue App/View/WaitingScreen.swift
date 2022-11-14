//
//  WaitingScreen.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import SwiftUI

struct WaitingScreen: View {
    @StateObject var viewModel: ViewModel
    
    @Environment(\.scenePhase) var scenePhase
    
    init(ticket: Ticket, serviceType: ServiceType) {
        _viewModel = StateObject(wrappedValue: ViewModel(ticket: ticket, serviceType: serviceType))
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(viewModel.ticket.number)
                    .font(.largeTitle)
                    .padding()
            }
            .frame(width: 150, height: 70)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            )
            .padding(.top)
            VStack {
                Text("About")
                Text("\(viewModel.ticket.waitingTime) minutes")
                    .font(.title.bold())
                Text("remaining before your call")
                Spacer()
                Text("\(viewModel.ticket.waitingNumber) people are before you")
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 300)
            .background(.gray.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
                            
            NotificationEnableView()
            
            Spacer()
            Button {
//                viewModel.isShowingDelaySheet = true
                viewModel.ticket.waitingTime = 0
            } label: {
                Text("Delay call")
                    .frame(width: 130, height: 50)
            }
            .buttonStyle(.bordered)
            .tint(Color(red: 10/255, green: 132/255, blue: 255/255))
        }
        .background(viewModel.ticket.waitingTime == 0 ? Color(red: 108/255, green: 184/255, blue: 48/255, opacity: 0.6) : Color(UIColor.systemBackground))
        .onAppear {
            viewModel.initializeView()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                viewModel.startCountdownTimer()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
                viewModel.stopTimer()
            }
        }
        .sheet(isPresented: $viewModel.isShowingDelaySheet) {
            DelayScreen(viewModel: viewModel)
                .presentationDetents([.fraction(0.40)])
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button("Cancel") {
                    viewModel.isShowingAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .alert("Cancel Ticket", isPresented: $viewModel.isShowingAlert) {
            Button("Keep ticket", role: .cancel) {}
            Button("Cancel ticket", role: .destructive) {
                viewModel.cancelTicket()
            }
        } message: {
            Text("Are you sure you want to cancel your ticket? This cannot be reversed!")
        }
        .navigationTitle(viewModel.serviceType.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

struct WaitingScreen_Previews: PreviewProvider {
    static var previews: some View {
        WaitingScreen(ticket: Ticket(id: "id2", number: "sd", waitingTime: 19, waitingNumber: 3, deskNumber: nil), serviceType: ServiceType(id: "sdf", title: "Valami"))
    }
}
