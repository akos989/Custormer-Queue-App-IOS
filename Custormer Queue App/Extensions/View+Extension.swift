//
//  View+Extension.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 23..
//

import SwiftUI

extension View {
    func dynamicForegroundColor(currentValue: Int, colorDictionary: [Int: Color]) -> some View {
        modifier(DynamicForegoundColor(currentValue: currentValue, colorDictionary: colorDictionary))
    }
    
    func progressViewOverlay(showingProgess: Bool, title: String = "Loading...") -> some View {
        modifier(ProgressViewOverlay(showingProgress: showingProgess, title: title))
    }
    
    func errorHandler(errorMessages: Binding<[String]>) -> some View {
        modifier(ErrorHandler(errorMessages: errorMessages))
    }
}
