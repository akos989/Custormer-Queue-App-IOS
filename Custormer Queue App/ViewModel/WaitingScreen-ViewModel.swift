//
//  WaitingScreen+ViewModel.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import Foundation
import UserNotifications

extension WaitingScreen {
    @MainActor class ViewModel: ObservableObject {
        @Published var ticket: Ticket
        @Published var serviceType: ServiceType
        @Published var isShowingDelaySheet = false
        @Published var isShowingAlert = false
        @Published var remainingMinutes: Int?
        @Published var isLoading = false
        @Published var loadingMessage = ""
                
        init(ticket: Ticket, serviceType: ServiceType, needRefresh: Bool) {
            self.ticket = ticket
            self.serviceType = serviceType
            calculateRemainingTime()
            if needRefresh {
                fetchTicket()
            }
        }
        
        func calculateRemainingTime() {
            Task { @MainActor in
                if let callTime = ticket.callTime {
                    let dateDifferance = Calendar.current.dateComponents([.minute], from: Date(), to: callTime)
                    remainingMinutes = dateDifferance.minute
                    
                    if let remainingMinutes = remainingMinutes {
                        if remainingMinutes > 5 * 60 {
                            scheduleLocalNotificationAfter(minutes: Double(remainingMinutes - 5), title: "5 minutes left till call", subtitle: "Your ticket is soon being called, please update the time in the application to see exact call time.", notificationId: "9d8d3a5f-505f-4dd8-927d-40dc919705cd")
                        }
                        if remainingMinutes > 0 {
                            scheduleLocalNotificationAfter(minutes: Double(remainingMinutes), title: "Ticket time is up", subtitle: "Your ticket is being called, go to the given desk.", notificationId: "c2f4f569-0dbd-48cc-9413-d857eeebb6f6")
                        }
                    }
                } else {
                    remainingMinutes = nil
                }
            }
        }
        
        func delayCallWith(minutes: Int) {
            isLoading = true
            loadingMessage = "We are trying to delay your ticket"
            Task { @MainActor in
                do {
                    let delayedTicket = try await NetworkService.delayCallWith(ticketId: ticket.id, minutes: minutes)
                    isLoading = false
                    ticket = delayedTicket
                    calculateRemainingTime()
                } catch AppError.serverError(let message), AppError.badRequest(let message), AppError.urlError(let message), AppError.unknown(let message) {
                    isLoading = false
                    ErrorHandlerService.shared.errorMessages.append(message)
                }
            }
        }
        
        func cancelTicket() {
            isLoading = true
            loadingMessage = "Cancalling your ticket..."
            Task { @MainActor in
                do {
                    try await NetworkService.cancelTicket(ticketId: ticket.id)
                    isLoading = false
                    UserDefaults.standard.removeObject(forKey: AppConstants.ACTIVE_TICKET_KEY)
                    UserDefaults.standard.removeObject(forKey: AppConstants.ACTIVE_SERVICETYPE_KEY)
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    NavigationService.shared.goToHomePage()
                }  catch AppError.serverError(let message), AppError.badRequest(let message), AppError.urlError(let message), AppError.unknown(let message) {
                    isLoading = false
                    ErrorHandlerService.shared.errorMessages.append(message)
                }
            }
        }
        
        func fetchTicket() {
            isLoading = true
            loadingMessage = "Refreshing your ticket..."
            Task { @MainActor in
                do {
                    isLoading = false
                    ticket = try await NetworkService.fetchTicket(ticketId: ticket.id)
                    calculateRemainingTime()
                    saveToUserDefault()
                }  catch AppError.serverError(let message), AppError.badRequest(let message), AppError.urlError(let message), AppError.unknown(let message) {
                    isLoading = false
                    UserDefaults.standard.removeObject(forKey: AppConstants.ACTIVE_TICKET_KEY)
                    UserDefaults.standard.removeObject(forKey: AppConstants.ACTIVE_SERVICETYPE_KEY)
                    NavigationService.shared.goToHomePage()
                    ErrorHandlerService.shared.errorMessages.append(message)
                } catch {
                    ErrorHandlerService.shared.errorMessages.append("Unknown error occured")
                }
            }
        }
        
        func saveToUserDefault() {
            do {
                try UserDefaults.saveObject(value: ticket, forKey: AppConstants.ACTIVE_TICKET_KEY)
            } catch {
                ErrorHandlerService.shared.errorMessages.append("Could not save refreshed ticket to local storage")
            }
        }
        
        func scheduleLocalNotificationAfter(minutes: Double, title: String, subtitle: String, notificationId: String) {
            let center = UNUserNotificationCenter.current()
            
            let addRequest = {
                let content = UNMutableNotificationContent()
                content.title = title
                content.subtitle = subtitle
                content.sound = UNNotificationSound.default
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: minutes, repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
            
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    addRequest()
                } else {
                    center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            addRequest()
                        } else {
                            print("D'oh")
                        }
                    }
                }
            }
            
        }
    }
}
