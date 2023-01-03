//
//  NotificationView.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 26..
//

import SwiftUI

struct NotificationView: View {
    var message: String
    var color: Color
    var onDismiss: (() -> Void)
    
    var body: some View {
        HStack {
            Text(message)
                .frame(minWidth: 200, alignment: .leading)
                .padding(.trailing)
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .onTapGesture(perform: onDismiss)
        }
        .padding()
        .background(color.opacity(0.8), in: RoundedRectangle(cornerRadius: 16.0))
        .frame(maxWidth: .infinity)
        .padding()
        .compositingGroup()
        .shadow(color: .black, radius: 2, x: 1, y: 1)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(message: "Some error message here", color: .red) {
            print("Element removed")
        }
    }
}
