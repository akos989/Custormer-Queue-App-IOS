//
//  WelcomeScreen-ViewModel.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 23..
//

import CodeScanner
import SwiftUI

extension WelcomeScreen {
    @MainActor class ViewModel: ObservableObject {
        @Published var isShowingScanner = false
        @Published var isLoading = false
        
        init() {
            let activeTicket: Ticket? = UserDefaults.loadObject(forKey: AppConstants.ACTIVE_TICKET_KEY)
            let activeServiceType: ServiceType? = UserDefaults.loadObject(forKey: AppConstants.ACTIVE_SERVICETYPE_KEY)
            
            if let activeTicket = activeTicket,
               let activeServiceType = activeServiceType {
                Task { @MainActor in
                    NavigationService.shared.goToWaitingScreen(ticket: activeTicket, serviceType: activeServiceType, needRefresh: true)
                }
            }
        }

        func handleScan(result: Result<ScanResult, ScanError>) {
            isShowingScanner = false
            isLoading = true
            switch result {
                case .success(let result):
                    Task {
                        do {
                            let scannedCustomerService = try await NetworkService.fetchServiceTypesFor(customerServiceId: result.string)
                            isLoading = false
                            NavigationService.shared.goToServiceTypesScreen(customerService: scannedCustomerService)
                        } catch AppError.serverError(let message), AppError.badRequest(let message), AppError.urlError(let message), AppError.unknown(let message) {
                            isLoading = false
                            ErrorHandlerService.shared.errorMessages.append(message)
                        }
                    }
                case .failure(let error):
                    print("Scanning error:", error.localizedDescription)
            }
        }
    }
}
