//
//  ErrorHandler.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 26..
//

import SwiftUI

struct ErrorHandler: ViewModifier {
    @Binding var errorMessages: [String]
    @State private var errorCards = [ErrorCard]()
    
    var slidingInterpolationSpring = Animation.interpolatingSpring(stiffness: 60, damping: 7, initialVelocity: 5)
    var dropDownInterpolationSpring = Animation.interpolatingSpring(stiffness: 30, damping: 7, initialVelocity: 2)
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            VStack {
                ForEach(errorCards.reversed()) { element in
                    NotificationView(message: element.message, color: .red) {
                        if let index = errorCards.firstIndex(where: { $0.id == element.id }) {
                            removeError(at: index)
                        }
                    }
                    .offset(element.offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if let index = errorCards.firstIndex(where: { $0.id == element.id }) {
                                    errorCards[index].offset = CGSize(width: gesture.translation.width, height: 0)
                                }
                            }
                            .onEnded { value in
                                if let index = errorCards.firstIndex(where: { $0.id == element.id }) {
                                    let locationDifferance = value.location.x - value.startLocation.x
                                    if value.predictedEndTranslation.width < -300 || locationDifferance < -200 {
                                        errorCards[index].offset = CGSize(width: -500, height: 0)
                                        removeError(at: index)
                                    } else if value.predictedEndTranslation.width > 300 || locationDifferance > 200 {
                                        errorCards[index].offset = CGSize(width: 500, height: 0)
                                        removeError(at: index)
                                    } else {
                                        errorCards[index].offset = .zero
                                    }
                                }
                            }
                    )
                    .animation(slidingInterpolationSpring, value: element.offset)
                }
            }
            .frame(alignment: .top)
        }
        .onChange(of: errorMessages) { [errorMessages] newState in
            let countDifferance = newState.count - errorMessages.count
            if countDifferance >= 0 {
                addErrorCard()
            }
        }
    }
    
    private func addErrorCard() {
        let errorId = UUID()
        let timeToLive = errorCards.count > 0 ? (6 + errorCards.count * 2) : 7
        let newErrorCard = ErrorCard(id: errorId, offset: CGSize(width: -500, height: 0), message: errorMessages.last ?? "Unknown error message", timeToLive: timeToLive) {
            if let index = errorCards.firstIndex(where: { $0.id == errorId }) {
                withAnimation(dropDownInterpolationSpring) {
                    removeError(at: index)
                }
            }
        }
        errorCards.append(newErrorCard)
        withAnimation(slidingInterpolationSpring) {
            errorCards[errorCards.count - 1].offset = .zero
        }
    }
    
    private func removeError(at index: Int) {
        let _ = withAnimation(dropDownInterpolationSpring) {
            if errorCards.count > index {
                errorCards.remove(at: index)
            }
        }
        if errorMessages.count > index {
            errorMessages.remove(at: index)
        }
    }
}
