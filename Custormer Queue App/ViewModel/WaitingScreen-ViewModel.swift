//
//  WaitingScreen+ViewModel.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import Foundation
import Combine

extension WaitingScreen {
    @MainActor class ViewModel: ObservableObject {
        @Published var ticket: Ticket
        @Published var serviceType: ServiceType
        @Published var isShowingDelaySheet = false
        @Published var isShowingAlert = false
        
        private var timer: Timer.TimerPublisher?
        private var connectedTimer: Cancellable?
        private var timerCancellable = Set<AnyCancellable>()
                
        init(ticket: Ticket, serviceType: ServiceType) {
            self.ticket = ticket
            self.serviceType = serviceType
        }
        
        func initializeView() {
            startCountdownTimer()
            setupWebsocketConnection()
        }
        
        func delayCallWith(minutes: Int) {
            Task { @MainActor in
                do {
                    let _ = try await NetworkService.delayCallWith(ticketId: ticket.id, minutes: minutes)
                    ticket = .init(id: "id3", number: "3131", waitingTime: ticket.waitingTime + minutes, waitingNumber: ticket.waitingNumber + 3, deskNumber: nil)
                } catch {
                    print("Error while delaying ticket: \(error.localizedDescription)")
                }
            }
        }
        
        func cancelTicket() {
            UserDefaults.standard.removeObject(forKey: AppConstants.ACTIVE_TICKET_KEY)
            UserDefaults.standard.removeObject(forKey: AppConstants.ACTIVE_SERVICETYPE_KEY)
            UserDefaults.standard.removeObject(forKey: AppConstants.TIMER_START_DATE_KEY)
            
            NavigationService.shared.goToHomePage()
        }

        func startCountdownTimer() {
            if timer == nil {
                if let previousStartDate: Date = UserDefaults.loadObject(forKey: AppConstants.TIMER_START_DATE_KEY),
                   var previousStartTicket: Ticket = UserDefaults.loadObject(forKey: AppConstants.ACTIVE_TICKET_KEY) {
                    let currentDate = Date()
                    let diffComponents = Calendar.current.dateComponents([.minute, .second], from: previousStartDate, to: currentDate)
                    
                    if let minutes = diffComponents.minute,
                       let seconds = diffComponents.second {
                        print("minutes: \(minutes), seconds: \(seconds)")
                        previousStartTicket.waitingTime -= minutes + (seconds > 30 ? 1 : 0)
                    }
                    ticket = previousStartTicket
                }
                
                do {
                    try UserDefaults.saveObject(value: ticket, forKey: AppConstants.ACTIVE_TICKET_KEY)
                    try UserDefaults.saveObject(value: Date(), forKey: AppConstants.TIMER_START_DATE_KEY)
                } catch {
                    print("error while saving to user default: \(error.localizedDescription)")
                }
                
                let tempTimer = Timer.publish(every: 60, tolerance: 2, on: .main, in: .common)
                tempTimer
                    .sink { [ weak self ] date in
                        self?.ticket.waitingTime -= 1
                        print("timer fired: \(date)")
                    }
                    .store(in: &timerCancellable)
                connectedTimer = tempTimer.connect()

                timer = tempTimer
            }
        }
        
        func stopTimer() {
            timerCancellable.removeAll()
            connectedTimer?.cancel()
            timer = nil
        }
                
        func setupWebsocketConnection() {
            // Todo
        }
        
        func recieveMessageFromWebsocket() {
            //
        }
        
        func closeWebsocketConnection() {
            // Todo
        }
        
        deinit {
            // closeWebsocketConnection()
            print("View is deinited")
        }
    }
}
