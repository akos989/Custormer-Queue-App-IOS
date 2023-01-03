//
//  ServiceTypesScreen.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 24..
//

import SwiftUI

struct ServiceTypesScreen: View {
    @StateObject private var viewModel: ViewModel
    @StateObject var errorHandlerService = ErrorHandlerService.shared
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    init(customerService: CustomerService) {
        _viewModel = StateObject(wrappedValue: ViewModel(customerService: customerService))
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack {
                        Text("Number of people waiting")
                        Text("\(viewModel.customerService.waitingPeople)")
                            .font(.title)
                        Text("Approximate waiting time")
                        if let waitingTime = viewModel.customerService.waitingTime {
                            Text("\(waitingTime) minutes")
                                .font(.title)
                        } else {
                            Text("could not be calculated")
                        }
                    }
                    Divider()
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.customerService.serviceTypes) { serviceType in
                            VStack {
                                CardView(title: serviceType.name, bottomText: "Average handle time is \(serviceType.handleTime) minutes")
                                    .onTapGesture {
                                        viewModel.tap(serviceType: serviceType)
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(serviceType == viewModel.selectedServiceType ? .blue.opacity(0.4) : .blue.opacity(0))
                                            .frame(
                                                maxWidth: serviceType == viewModel.selectedServiceType ? .infinity : .zero,
                                                maxHeight: serviceType == viewModel.selectedServiceType ? .infinity : .zero
                                            )
                                            .allowsHitTesting(false)
                                            .animation(.easeOut(duration: 0.1), value: viewModel.selectedServiceType)
                                    }
                            }
                            .padding([.horizontal, .vertical])
                            .contextMenu {
                                if serviceType == viewModel.selectedServiceType {
                                    Button(role: .destructive) {
                                        viewModel.selectedServiceType = nil
                                    } label: {
                                        Label("Clear selection", systemImage: "xmark")
                                    }
                                } else {
                                    Button {
                                        viewModel.selectedServiceType = serviceType
                                    } label: {
                                        Label("Select option", systemImage: "checkmark")
                                    }
                                }
                            } preview: {
                                VStack {
                                    CardView(title: serviceType.name, bottomText: "Average handle time is \(serviceType.handleTime)")
                                        .padding()
                                }
                                .frame(width: 400)
                            }
                        }
                    }
                    .padding(.bottom, viewModel.selectedServiceType != nil ? 100 : 0)
                }
                Button {
                    viewModel.selectServiceType()
                } label:{
                    HStack(spacing: .zero) {
                        Text("Choose ")
                        Text(viewModel.selectedServiceType?.name ?? "")
                            .font(.headline.bold())
                            .padding(.trailing)
                        Image(systemName: "arrow.right")
                            .offset(y: 1)
                    }
                    .padding([.vertical, .horizontal])
                    .frame(height: 60)
                }
                .foregroundColor(.white)
                .background(.blue.opacity(0.95))
                .clipShape(Capsule())
                .offset(y: viewModel.selectedServiceType != nil ? -20 : 140)
                .animation(.easeOut(duration: 0.1), value: viewModel.selectedServiceType)
            }
        }
        .errorHandler(errorMessages: $errorHandlerService.errorMessages)
        .progressViewOverlay(showingProgess: viewModel.isLoading, title: "Creating ticket...")
        .navigationTitle(viewModel.customerService.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ServiceTypesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTypesScreen(customerService: CustomerService(name: "Vodafone", waitingPeople: 12, waitingTime: 43, serviceTypes: []))
    }
}
