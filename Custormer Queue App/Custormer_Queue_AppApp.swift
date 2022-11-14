//
//  Custormer_Queue_AppApp.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 23..
//

import SwiftUI

@main
struct Custormer_Queue_AppApp: App {
    @StateObject var navigationService = NavigationService.shared
    private var customerService = CustomerService(name: "valami", waitingNumber: 23, waitingDuration: 32, serviceTypes: [
        ServiceType(id: "id1", title: "valmai1"),
        ServiceType(id: "id2", title: "valmai2"),
        ServiceType(id: "id3", title: "valmai3"),
        ServiceType(id: "id4", title: "valmai4"),
    ])
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationService.paths) {
                WelcomeScreen()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                            case let .serviceTypes(customerService):
                                ServiceTypesScreen(customerService: customerService)
                            case let .waiting(ticket, serviceType):
                                WaitingScreen(ticket: ticket, serviceType: serviceType)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private var startView: some View {
        let activeTicket: Ticket? = UserDefaults.loadObject(forKey: AppConstants.ACTIVE_TICKET_KEY)
        let activeServiceType: ServiceType? = UserDefaults.loadObject(forKey: AppConstants.ACTIVE_SERVICETYPE_KEY)
        
        if let activeTicket = activeTicket,
           let activeServiceType = activeServiceType {
            WaitingScreen(ticket: activeTicket, serviceType: activeServiceType)
        } else {
            WelcomeScreen()
        }
    }    
}
