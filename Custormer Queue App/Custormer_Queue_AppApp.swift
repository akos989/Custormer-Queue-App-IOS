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
    
    private var customerService = CustomerService(name: "valami", waitingPeople: 23, waitingTime: 32, serviceTypes: [
        ServiceType(id: "id1", name: "valmai1", handleTime: 10),
        ServiceType(id: "id2", name: "valmai2", handleTime: 10),
        ServiceType(id: "id3", name: "valmai3", handleTime: 10),
        ServiceType(id: "id4", name: "valmai4", handleTime: 10),
    ])
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationService.paths) {
                WelcomeScreen()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                            case let .serviceTypes(customerService):
                                ServiceTypesScreen(customerService: customerService)
                            case let .waiting(ticket, serviceType, needRefresh):
                                WaitingScreen(ticket: ticket, serviceType: serviceType, needRefresh: needRefresh)
                        }
                    }
            }
        }
    }
}
