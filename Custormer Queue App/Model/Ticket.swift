//
//  Ticket.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import Foundation

struct Ticket: Codable, Identifiable, Hashable {
    let id: String
    let number: String
    var waitingTime: Int
    var waitingNumber: Int
    var deskNumber: Int?
}
