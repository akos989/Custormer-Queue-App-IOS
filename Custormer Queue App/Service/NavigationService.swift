//
//  NavigationService.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import SwiftUI

enum Route: Hashable {
    case serviceTypes(CustomerService)
    case waiting(Ticket, ServiceType)
}

class NavigationService: ObservableObject {
    static let shared = NavigationService()
    
    private init() {}
    
    @Published var paths = [Route]()
    
    func goToHomePage() {
        paths.removeAll()
    }
    
    func goToServiceTypesScreen(customerService: CustomerService) {
        paths.append(.serviceTypes(customerService))
    }
    
    func goToWaitingScreen(ticket: Ticket, serviceType: ServiceType) {
        paths.append(.waiting(ticket, serviceType))
    }
    
    func goBackOneLevel() {
        paths.removeLast()
    }
}
