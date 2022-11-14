//
//  UserDefaults+Extension.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 01..
//

import Foundation

extension UserDefaults {    
    static func saveObject<T: Encodable>(value: T, forKey key: String) throws {
        let encodedObject = try JSONEncoder().encode(value)
        UserDefaults.standard.set(encodedObject, forKey: key)
    }
    
    static func loadObject<T: Decodable>(forKey key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key),
           let decodedData = try? JSONDecoder().decode(T.self, from: data) {
            return decodedData
        } else {
            return nil
        }
    }
}
