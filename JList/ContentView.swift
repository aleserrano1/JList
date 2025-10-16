//
//  ContentView.swift
//  JList
//
//  Created by Turing on 11/20/24.
//

import SwiftUI
import SwiftData
import CoreLocation

// Color Pallet
let backgroundColorGray = Color(red: 28/255, green: 48/255, blue: 53/255)
let foregroundColorGray = Color(red: 49/255, green: 67/255, blue: 77/255)
let lightGrayColor = Color(red: 150/255, green: 167/255, blue: 175/255)
let greenColor = Color(red:64/255, green: 220/255, blue: 156/255)
let redColor = Color(red: 252/255, green: 87/255, blue: 93/255)
let yellowColor = Color(red: 255/255, green: 197/255, blue: 66/255)
let orangeColor = Color(red: 255/255, green: 151/255, blue: 75/255)
let blueColor = Color(red: 0/255, green: 97/255, blue: 255/255)

// Current User Variables
var currentUser: String = "defaultUser"

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    // Current State Color Varibale
    @State var currentColor: Color = yellowColor
    
    // Username and Password Variables
    @State private var username: String = ""
    @State private var password: String = ""
    
    // Login Checker Variable
    @State private var isLoggedIn: Bool = false
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) private var credentialsContext
    // Accounts Variable
    @Query var accounts: [UserCredentials]
    @Query var tasks: [Tasks]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                Color(backgroundColorGray).ignoresSafeArea(.all)
                
                VStack {
                    // Welcome and Sub Label
                    VStack {
                        // Welcome Label
                        Text("Welcome")
                            .frame(width: 320, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 35, weight: .bold))
                        
                        // Sub Label
                        Text("Ready \(Text("To-Do more").italic()) tasks!")
                            .frame(width: 320, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }.padding() // End of VStack
                    
                    // Rectangle Login Form
                    ZStack {
                        // Rectangle
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 320, height: 300)
                        .foregroundColor(foregroundColorGray)
                        
                        // Login Form
                        VStack {
                            // Login Label
                            Text("Login")
                                .foregroundColor(.white)
                                .font(.system(size: 35, weight: .bold))
                                .padding()
                            
                            // Username Text Field and User Icon
                            HStack {
                                // User Icon
                                Image(systemName: "person.fill")
                                    .frame(width: 50, height: 50)
                                    .background(Color(currentColor).opacity(0.4))
                                    .foregroundColor(currentColor)
                                    .cornerRadius(5)
                                
                                // Username Text Field
                                TextField("", text: $username, prompt: Text("Username").foregroundColor(.gray))
                                    .frame(width: 210, height:50)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(currentColor), lineWidth: 1.5))
                            }.padding() // End of HStack
                            
                            // Password Text Field and Lock Icon
                            HStack {
                                // Lock Icon
                                Image(systemName: "lock.fill")
                                    .frame(width: 50, height: 50)
                                    .background(Color(currentColor).opacity(0.4))
                                    .foregroundColor(currentColor)
                                    .cornerRadius(5)
                                
                                SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                                    .frame(width: 210, height:50)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(currentColor), lineWidth: 1.5))
                            } // End of HStack
                        } // End of VStack
                    }.padding() // End of ZStack
                    
                    // Login Button
                    Button {
                        login()
                    } label: {
                        Text("Login")
                            .bold()
                            .frame(width: 250, height: 55)
                            .background(Color(greenColor))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } // End of Login Button
                    
                    // Or Label with Lines
                    HStack {
                        // Left Line
                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundColor(.white)
                        
                        // Or Label
                        Text("Or")
                            .foregroundColor(.white)
                        
                        // Right Line
                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundColor(.white)
                    } // End of HStack
                    
                    // Sign Up Button
                    NavigationLink(destination: SignUpView(), label: {
                        Text("Sign Up")
                            .bold()
                            .frame(width: 250, height: 55)
                            .background(Color(greenColor).opacity(0.4))
                            .foregroundColor(greenColor)
                            .cornerRadius(10)
                    }) // End of NavigationLink
                } // End of VStack
            }.navigationDestination(isPresented: $isLoggedIn){TabBarView()} // End of ZStack
                .onAppear {
                    locationManager.requestLocation()
                    
                    // Assign your custom function to run every time the location changes
                    locationManager.onLocationUpdate = { newLocation in
                        // This will run every time the location updates
                        print("Location updated: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
    
                        for task in tasks {
                            let centerCoordinate = CLLocation(latitude: task.latitude, longitude: task.longitude)
                            if isLocation(newLocation, insideCircleWithCenter: centerCoordinate, radiusInMeters: task.radius) {
                                let notification = AppDelegate(notificationTitle: "You are in a circle for one of your Tasks!", notificationSubtitle: "Don't forget to: \(task.content)")
                                notification.scheduleNotification()
                                locationManager.stopTracking()
                            }
                        } // End of For-Loop
                    }
                }
        } // End of NavigationStack
    } // End of Body
    
    
    // Login Function
    func login() {
        // Iterates through accounts
        for accnt in accounts {
            // If accnt matches username and password; Change currentUser and change View
            if accnt.username == username && accnt.password == password {
                currentUser = accnt.username
                currentColor = greenColor
                isLoggedIn.toggle()
                username = ""
                password = ""
                return
            }
        } // End of For-Loop
        currentColor = redColor
    } // End of Login Function
    
    func isLocation(_ location: CLLocation, insideCircleWithCenter center: CLLocation, radiusInMeters: CLLocationDistance) -> Bool {
        // Calculate the distance between the location and the center of the circle
        let distance = location.distance(from: center)
        
        // Check if the distance is less than or equal to the radius
        return distance <= radiusInMeters
    }
} // End of Struct

#Preview {
    ContentView()
}
