//
//  NetworkService.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 23..
//

import Foundation

struct NetworkError: Decodable {
    let httpStatus: String
    let message: String
}

enum AppError: Error {
    case urlError(String)
    case badRequest(String)
    case serverError(String)
    case unknown(String)
}

class NetworkService {
    static private let BASE_URL = "http://192.168.10.196:8080/customer-queue-app/api"
    
    static func fetchServiceTypesFor(customerServiceId: String) async throws -> CustomerService {
        let urlString = BASE_URL + "/customerServices/\(customerServiceId)"
        guard let url = URL(string: urlString) else { throw AppError.urlError("Wrong URL during server communication") }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        try verifyResponse(data: data, response: response)
        
        let customerServices = try JSONDecoder().decode(CustomerService.self, from: data)
        
        return customerServices
    }
    
    static func getTicketForService(serviceTypeId: String) async throws -> Ticket {
        let urlString = BASE_URL + "/tickets/forServiceType/\(serviceTypeId)"
        guard let url = URL(string: urlString) else { throw AppError.urlError("Wrong URL during server communication") }
        
        let request = URLRequest(url: url, method: .POST)
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: Data())
        try verifyResponse(data: data, response: response)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let ticket = try decoder.decode(Ticket.self, from: data)
        
        return ticket
    }
    
    static func delayCallWith(ticketId: String, minutes: Int) async throws -> Ticket {
        let urlString = BASE_URL + "/tickets/\(ticketId)/delay"
        guard var url = URL(string: urlString) else { throw AppError.urlError("Wrong URL during server communication") }
        url.append(queryItems: [URLQueryItem(name: "minutes", value: "\(minutes)")])
    
        let request = URLRequest(url: url, method: .PATCH)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try verifyResponse(data: data, response: response)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let ticket = try decoder.decode(Ticket.self, from: data)
        
        return ticket
    }
    
    static func cancelTicket(ticketId: String) async throws {
        let urlString = BASE_URL + "/tickets/\(ticketId)"
        guard let url = URL(string: urlString) else { throw AppError.urlError("Wrong URL during server communication") }
        let request = URLRequest(url: url, method: .DELETE)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try verifyResponse(data: data, response: response)
    }
    
    static func fetchTicket(ticketId: String) async throws -> Ticket {
        let urlString = BASE_URL + "/tickets/\(ticketId)"
        guard let url = URL(string: urlString) else { throw AppError.urlError("Wrong URL during server communication") }
        let request = URLRequest(url: url, method: .GET)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try verifyResponse(data: data, response: response)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let ticket = try decoder.decode(Ticket.self, from: data)
        
        return ticket
    }
    
    private static func verifyResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.unknown("Some unexpected error occured during communication with the server")
        }
        if !(200...299).contains(httpResponse.statusCode) {
            do {
                let errorBody = try JSONDecoder().decode(NetworkError.self, from: data)
                throw AppError.serverError("\(errorBody.httpStatus): \(errorBody.message)")
            } catch AppError.serverError(let message) {
                throw AppError.serverError(message)
            } catch {
                throw AppError.unknown("Some unexpected error occured during communication with the server")
            }
        }
    }
}
