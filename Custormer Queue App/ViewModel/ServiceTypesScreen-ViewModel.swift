//
//  ServiceTypesScreen-ViewModel.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 25..
//

import Foundation
import SwiftUI

extension ServiceTypesScreen {
    @MainActor class ViewModel: ObservableObject {
        @Published var customerService: CustomerService
        @Published var selectedServiceType: ServiceType?
        
        init(customerService: CustomerService) {
            self.customerService = customerService
        }
        
        func tap(serviceType: ServiceType) {
            if serviceType == selectedServiceType {
                selectedServiceType = nil
            } else {
                selectedServiceType = serviceType
            }
        }
        
        func selectServiceType() {
            guard let selectedServiceType = selectedServiceType else { return }
            
            Task {
                do {
                    let ticket = try await NetworkService.getTicketForService(serviceTypeId: selectedServiceType.id)
                    saveToUserDefault(ticket: ticket, serviceType: selectedServiceType)
                    NavigationService.shared.goToWaitingScreen(ticket: ticket, serviceType: selectedServiceType)
                } catch {
                    print("Error while fetching ticket: \(error.localizedDescription)")
                }
            }
        }
        
        func saveToUserDefault(ticket: Ticket, serviceType: ServiceType) {
            do {
                try UserDefaults.saveObject(value: ticket, forKey: AppConstants.ACTIVE_TICKET_KEY)
                try UserDefaults.saveObject(value: serviceType, forKey: AppConstants.ACTIVE_SERVICETYPE_KEY)
            } catch {
                print("Saving to UserDefaults failed with error: \(error.localizedDescription)")
            }
        }
    }
}
