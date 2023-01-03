//
//  CustomerService.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 24..
//

import Foundation

struct CustomerService: Decodable, Hashable {
    let name: String
    var waitingPeople: Int
    var waitingTime: Int?
    let serviceTypes: [ServiceType]
}
