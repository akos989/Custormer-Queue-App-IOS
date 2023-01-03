//
//  ErrorHandlerService.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 26..
//

import SwiftUI

class ErrorHandlerService: ObservableObject {
    static let shared = ErrorHandlerService()
    
    private init() {}
    
    @Published var errorMessages = [String]()
}
