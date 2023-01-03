//
//  ProgressViewOverlay.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 25..
//

import SwiftUI

struct ProgressViewOverlay: ViewModifier {
    var showingProgress: Bool
    var title = "Loading..."
    
    func body(content: Content) -> some View {
        if showingProgress {
            ZStack {
                content
                    .overlay {
                        VStack {
                            Color.gray.opacity(0.5)
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                ProgressView(title)
                    .foregroundColor(.primary)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16.0))
            }
        } else {
            content
        }
    }
}
