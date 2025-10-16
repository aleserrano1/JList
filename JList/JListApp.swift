//
//  JListApp.swift
//  JList
//
//  Created by Turing on 11/20/24.
//

import SwiftUI
import SwiftData
import UserNotifications
import CoreLocation

@main
struct JListApp: App {

    //@StateObject private var locationManager = LocationManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {

                } // End of onAppear
        }
        .modelContainer(for: [UserCredentials.self, UserFriends.self, Lists.self, User.self, Tasks.self, TextMessages.self, ProfilePicture.self])
    }
    
}




class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var notificationTitle: String
    var notificationSubtitle: String
        
    // Default initializer
    override init() {
        // Provide default values if needed
        self.notificationTitle = "Default Title"
        self.notificationSubtitle = "Default Subtitle"
        super.init()
    }

    // Custom initializer (optional, for later use)
    init(notificationTitle: String, notificationSubtitle: String) {
        self.notificationTitle = notificationTitle
        self.notificationSubtitle = notificationSubtitle
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Request permissions
        requestPermissionNotifications()
        
        // Set the UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // Delegate method to handle notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // This is called when a notification is received while the app is in the foreground
        print("Received notification while in foreground: \(notification.request.content.body)")
        
        // You can customize the behavior here, for example, by showing an alert manually
        return [.banner, .sound] // Show banner and play sound when notification arrives in the foreground
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // This is called when the user taps on the notification
        print("User tapped on notification")
        // Handle response to the notification here
    }
    
    
    // Requestes Permission to send Notification
    func requestPermissionNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    } // End of requestPermissionNotification Function
    
    
    // Schedule Notification
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.subtitle = notificationSubtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    } // End of Function
}

