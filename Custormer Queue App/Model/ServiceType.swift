//
//  ServiceType.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 23..
//

import Foundation

struct ServiceType: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let handleTime: Int
}
