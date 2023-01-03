//
//  ErrorCard.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2023. 01. 03..
//

import Foundation

struct ErrorCard: Identifiable {
    let id: UUID
    var offset: CGSize
    var message: String
    let timeToLive: Int
    
    init(id: UUID = UUID(), offset: CGSize, message: String, timeToLive: Int = 7, onTimerEnded: @escaping () -> Void) {
        self.id = id
        self.offset = offset
        self.message = message
        self.timeToLive = timeToLive
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(timeToLive)) {
            Task { @MainActor in
                onTimerEnded()
            }
        }
    }
}
