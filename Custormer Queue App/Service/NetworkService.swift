//
//  NetworkService.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 23..
//

import Foundation

enum MyError: Error {
    case urlError(String)
}

class NetworkService {
    static private let baseUrl = "https://someurl.com/servicetypes"
    static func fetchServiceTypesFor(customerServiceId: String) async throws -> CustomerService {
        let urlString = baseUrl + "/list/\(customerServiceId)"
        guard let url = URL(string: urlString) else { throw MyError.urlError("url not good") }
        
        let (data, _) = try await FakeURLSession.data(from: url)
        let customerServices = try JSONDecoder().decode(CustomerService.self, from: data)
        
        return customerServices
    }
    
    static func getTicketForService(serviceTypeId: String) async throws -> Ticket {
        let urlString = baseUrl + "/getTicket/\(serviceTypeId)"
        guard let url = URL(string: urlString) else { throw MyError.urlError("url not good") }
        
        let (data, _) = try await FakeURLSession.data(from: url)
        let ticket = try JSONDecoder().decode(Ticket.self, from: data)
        
        return ticket
    }
    
    static func delayCallWith(ticketId: String, minutes: Int) async throws -> Ticket {
        let urlString = baseUrl + "/delayTicket/\(ticketId)"
        guard var url = URL(string: urlString) else { throw MyError.urlError("url not good") }
        url.append(queryItems: [URLQueryItem(name: "delay", value: "\(minutes)")])
        
        let (data, _) = try await FakeURLSession.data(from: url)
        var ticket = try JSONDecoder().decode(Ticket.self, from: data)
        
        return ticket
    }
    
    private class FakeURLSession {
        static func data(from fromUrl: URL) async throws -> (Data, URLResponse) {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            let contollerPathComponent = fromUrl.pathComponents[2]
            
            switch contollerPathComponent {
                case "list":
                    guard let url = Bundle.main.url(forResource: "servicetypes", withExtension: "json") else {
                        fatalError("Failed to locate servicetypes.json in bundle.")
                    }
                    
                    guard let data = try? Data(contentsOf: url) else {
                        fatalError("Failed to load \(contollerPathComponent) from bundle.")
                    }
                    return (data, URLResponse())
                    
                case "getTicket":
                    guard let url = Bundle.main.url(forResource: "ticket-nodesk", withExtension: "json") else {
                        fatalError("Failed to locate ticket-nodesk.json in bundle.")
                    }
                    
                    guard let data = try? Data(contentsOf: url) else {
                        fatalError("Failed to load ticket-nodesk.json from bundle.")
                    }
                    return (data, URLResponse())
                    
                case "delayTicket":
                    guard let url = Bundle.main.url(forResource: "ticket-nodesk", withExtension: "json") else {
                        fatalError("Failed to locate ticket-nodesk.json in bundle.")
                    }
                    
                    guard let data = try? Data(contentsOf: url) else {
                        fatalError("Failed to load ticket-nodesk.json from bundle.")
                    }
                    return (data, URLResponse())
                    
                default:
                    return (Data(), URLResponse())
            }
        }
    }
}
