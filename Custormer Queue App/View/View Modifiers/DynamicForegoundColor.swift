//
//  DynamicForegoundColor.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 23..
//

import SwiftUI

struct DynamicForegoundColor: ViewModifier {
    var currentValue: Int
    var colorDictionary: [Int: Color]
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(getForegroundColor())
    }
    
    func getForegroundColor() -> Color {
        let sortedColorDicionaryKeys = colorDictionary.keys.sorted()
        for upperLimit in sortedColorDicionaryKeys {
            if currentValue < upperLimit {
                return colorDictionary[upperLimit]!
            }
        }
        return .primary
    }
}
