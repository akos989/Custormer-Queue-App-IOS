//
//  ServiceTypesScreen.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 10. 24..
//

import SwiftUI

struct ServiceTypesScreen: View {
    @StateObject private var viewModel: ViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    init(customerService: CustomerService) {
        _viewModel = StateObject(wrappedValue: ViewModel(customerService: customerService))
        print("servicetype screen init")
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack {
                        Text("Number of people waiting")
                        Text("\(viewModel.customerService.waitingNumber)")
                            .font(.title)
                        Text("Approximate waiting time")
                        Text("\(viewModel.customerService.waitingDuration) minutes")
                            .font(.title)
                    }
                    Divider()
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.customerService.serviceTypes) { serviceType in
                            VStack {
                                CardView(title: serviceType.title)
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
                                    CardView(title: serviceType.title)
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
//                        let ticket = Ticket(id: "some", number: "3333", waitingTime: 33, waitingNumber: 2, deskNumber: nil)
//                        paths.goToWaitingScreen(ticket: ticket, serviceType: ServiceType(id: "id", title: "sdf id is good"))
                } label:{
                    HStack(spacing: .zero) {
                        Text("Choose ")
                        Text(viewModel.selectedServiceType?.title ?? "")
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
        .navigationTitle(viewModel.customerService.name)
    }
}

struct ServiceTypesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ServiceTypesScreen(customerService: CustomerService(name: "Vodafone", waitingNumber: 12, waitingDuration: 43, serviceTypes: []))
    }
}
