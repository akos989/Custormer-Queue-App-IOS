//
//  NotificationEnableView.swift
//  Custormer Queue App
//
//  Created by Morvai Ákos on 2022. 11. 12..
//

import SwiftUI
import UserNotifications

struct NotificationEnableView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var notificationPermission: UNAuthorizationStatus = .authorized
    
    private var notificationsEnabled: Bool {
        notificationPermission == .authorized || notificationPermission == .ephemeral || notificationPermission == .provisional
    }
    
    var body: some View {
        VStack {
            Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash.fill")
                .foregroundColor(notificationsEnabled ? .blue : .red)
                .animation(.easeOut(duration: 0.4), value: notificationsEnabled)
            
            switch notificationPermission {
                case .notDetermined, .denied:
                    Text("Notifications are turned off")
                        .font(.caption.weight(.light))
                    Button("Turn on notifications") {
                        if notificationPermission == .notDetermined {
                            requestNewPermission()
                        } else if notificationPermission == .denied {
                            openAppNotificationSettings()
                        }
                    }
                default:
                    Text("Notifications are turned on")
                        .font(.caption.weight(.light))
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                checkNotificationsPermission()
            }
        }
    }
    
    private func checkNotificationsPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            notificationPermission = settings.authorizationStatus
        }
    }
    
    private func requestNewPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func openAppNotificationSettings() {
        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
            Task { @MainActor in
                await UIApplication.shared.open(url)
            }
        }
    }
}

struct NotificationEnableView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationEnableView()
    }
}
