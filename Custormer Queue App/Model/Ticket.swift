//
//  Ticket.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 31..
//

import Foundation

struct Ticket: Codable, Identifiable, Hashable {
    let id: String
    let serviceTypeName: String
    let ticketNumber: Int
    var callTime: Date?
    var waitingPeopleNumber: Int
    var handleDesk: Int
}
