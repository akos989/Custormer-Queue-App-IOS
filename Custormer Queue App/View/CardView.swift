//
//  CardView.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 25..
//

import SwiftUI

struct CardView: View {
    let title: String
    let subtitle: String
    let bottomText: String
    let backgroundColor: Color
    let borderColor: Color
    
    init(title: String, subtitle: String = "", bottomText: String = "", backgroundColor: Color = Color(red: 217/255, green: 217/255, blue: 217/255), borderColor: Color = Color.black) {
        self.title = title
        self.subtitle = subtitle
        self.bottomText = bottomText
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline.bold())
                .multilineTextAlignment(.center)
                .lineLimit(3)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            if !bottomText.isEmpty {
                Spacer()
                Text(bottomText)
                    .foregroundColor(.black.opacity(0.7))                
            }
        }
        .padding()
        .frame(minWidth: 150, maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: borderColor, radius: 2, x: 2, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Upload balance for this phone")
    }
}
