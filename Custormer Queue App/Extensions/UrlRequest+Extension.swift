//
//  UrlRequest+Extension.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 25..
//

import Foundation

extension URLRequest {
    enum Method: String {
        case GET, POST, PUT, PATCH, DELETE
    }
    
    init(url: URL, method: URLRequest.Method) {
        self.init(url: url)
        httpMethod = method.rawValue
    }
}
