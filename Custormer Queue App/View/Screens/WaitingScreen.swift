//
//  WaitingScreen.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import SwiftUI

struct WaitingScreen: View {
    @StateObject var viewModel: ViewModel
    @StateObject var errorHandlerService = ErrorHandlerService.shared
    
    let timer = Timer.publish(every: 60, tolerance: 3, on: .main, in: .common).autoconnect()
        
    init(ticket: Ticket, serviceType: ServiceType, needRefresh: Bool) {
        _viewModel = StateObject(wrappedValue: ViewModel(ticket: ticket, serviceType: serviceType, needRefresh: needRefresh))
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    Text("\(viewModel.ticket.ticketNumber)")
                        .font(.system(size: 60))
                        .padding()
                }
                .frame(width: 250, height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary, lineWidth: 2)
                )
                Spacer()
                if viewModel.ticket.handleDesk > 0 {
                    Spacer()
                    Text("Your ticket is being called, go to")
                    Spacer()
                    Text("Desk \(viewModel.ticket.handleDesk)")
                        .font(.largeTitle)
                    Spacer()
                } else {
                    if let remainingMinutes = viewModel.remainingMinutes {
                        Text("About")
                        Text("\(remainingMinutes) minutes")
                            .font(.title.bold())
                            .dynamicForegroundColor(currentValue: remainingMinutes, colorDictionary: [5: .red, 15: .yellow])
                        Text("remaining before your call")
                        if remainingMinutes <= 0 {
                            Text("Refresh the application, as your ticket might have been called! In case it hasn't go to customer service as it will be called soon.")
                        }
                    } else {
                        Text("Remaining time could not be calculated as no help desk is open at the moment")
                    }
                    Spacer()
                    Text("\(viewModel.ticket.waitingPeopleNumber) people are before you")
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 300)
            .background(.gray.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
            
            if let minutes = viewModel.remainingMinutes, minutes > 0 {
                Spacer()
                NotificationEnableView()
            }
            Spacer()
            
            if let minutes = viewModel.remainingMinutes, minutes > 0 {
                Spacer()
                Spacer()
                Button {
                    viewModel.isShowingDelaySheet = true
                } label: {
                    Text("Delay call")
                        .frame(width: 130, height: 50)
                }
                .buttonStyle(.bordered)
                .tint(Color(red: 10/255, green: 132/255, blue: 255/255))
            }
        }
        .background(determineBackgroundColor())
        .progressViewOverlay(showingProgess: viewModel.isLoading, title: viewModel.loadingMessage)
        .errorHandler(errorMessages: $errorHandlerService.errorMessages)
        .onReceive(timer) { _ in
            viewModel.calculateRemainingTime()
        }
        .sheet(isPresented: $viewModel.isShowingDelaySheet) {
            DelayScreen(viewModel: viewModel)
                .presentationDetents([.fraction(0.40)])
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.fetchTicket()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }

            }
            ToolbarItem(placement: .destructiveAction) {
                Button("Cancel") {
                    viewModel.isShowingAlert = true
                }
                .foregroundColor(.red)
                .disabled(viewModel.isLoading)
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
        .navigationTitle(viewModel.serviceType.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    func determineBackgroundColor() -> Color {
        if let minutes = viewModel.remainingMinutes, minutes <= 0 {
            return Color(red: 108/255, green: 184/255, blue: 48/255, opacity: 0.6)
        }
        return Color(UIColor.systemBackground)
    }
}

//struct WaitingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingScreen(ticket: Ticket(id: "id2", number: "sd", waitingTime: 19, waitingPeopleNumber: 3, deskNumber: nil), serviceType: ServiceType(id: "sdf", name: "Valami", handleTime: 10))
//    }
//}
