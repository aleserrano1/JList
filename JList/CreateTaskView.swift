//
//  CreateTaskView.swift
//  JList
//
//  Created by Turing on 12/6/24.
//

import SwiftUI
import SwiftData
import MapKit

struct CreateTaskView: View {
    // List ID
    var listID: Int
    var colorLayout: Color
    
    // Clicked Location Variable
    @State private var clickedLocation = CLLocationCoordinate2D(latitude: 25.740591151787363, longitude: -80.27851866746471)
    
    // Map Camera Position Variable
    @State var camera: MapCameraPosition = .automatic
    
    // Dismiss Variable
    @Environment(\.dismiss) var dismiss
    
    // Done is Disabled Variables
    @State private var doneDisabled = true
    @State private var taskFieldEmpty = true
    @State private var locationFieldEmpty = true
    
    // Task Text Field Variable
    @State private var taskText = ""
    
    // Location Text Field Variable
    @State private var locationText = ""
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) private var context
    // Friends Variable
    @Query var friends: [UserFriends]
    // Tasks Variable
    @Query var tasks: [Tasks]
    // Lists Variable
    @Query var users: [User]
    
    // Array of Assign Options Variable
    @State private var assignOptions: [String] = []
    
    // Assigned To at index Variable
    @State private var assignedTo = 0
    
    // Circel Radius Variable
    @State private var circleRadius = 10.0
    
    
    var body: some View {
        ZStack {
            // Background Color
            Color(backgroundColorGray).ignoresSafeArea(.all)
            
            ScrollView {
                VStack {
                    // Control Top Bar
                    HStack {
                        // Cancel Button
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 20))
                        } // End of Button
                        
                        // New List Label
                        Text("New Task")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .padding(70)
                        
                        // Done Button
                        Button {
                            createTask()
                            dismiss()
                            
                            if assignOptions[assignedTo] != "Me" {
                                addFriendToList()
                            }
                        } label: {
                            Text("Done")
                                .font(.system(size: 20, weight: .bold))
                        }.onChange(of: taskText){
                            if taskFieldEmpty == false && locationFieldEmpty == false {
                                doneDisabled = false
                            } else {
                                doneDisabled = true
                            }
                        }.onChange(of: locationText){
                            if taskFieldEmpty == false && locationFieldEmpty == false {
                                doneDisabled = false
                            } else {
                                doneDisabled = true
                            }
                        }.disabled(doneDisabled) // End of Button
                        
                        
                    }.frame(height: 50) // End of HStack
                    
                    
                    // Map & Slide Bar
                    ZStack {
                        // Map
                        MapReader { proxy in
                            Map(position: $camera) {
                                Marker("", systemImage: "mappin", coordinate: clickedLocation)
                                MapCircle(center: clickedLocation, radius: circleRadius)
                                    .foregroundStyle(greenColor.opacity(0.50))
                            }
                            .onTapGesture { position in
                                if let coordinate = proxy.convert(position, from: .local) {
                                    let latitude = coordinate.latitude
                                    let longitude = coordinate.longitude
                                    clickedLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                }
                            }
                        }.frame(width: 350,height: 500).cornerRadius(15)// End of MapReader
                        
                        // Slider
                        Slider(value: $circleRadius, in: 20...300, step: 1)
                            .frame(width: 300, height: 450, alignment: .bottom)

                    } // End of ZStack
                    
                    
                    // Task & Location Text Fields
                    ZStack {
                        // Background Rectangle
                        RoundedRectangle(cornerRadius: 15.0)
                            .frame(width: 350 ,height: 240)
                            .foregroundColor(foregroundColorGray)
                        
                        VStack {
                            // Task Text Field
                            TextField("", text: $taskText, prompt: Text("Task").font(.system(size: 20, weight: .bold)).foregroundColor(lightGrayColor))
                                .frame(width: 300, height:50)
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(colorLayout), lineWidth: 1.5))
                                .multilineTextAlignment(.center).padding()
                                .padding(-16)
                                .onChange(of: taskText) { // Disables and Enables Done Button
                                    let trimmedTaskText = taskText.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if trimmedTaskText != "" {
                                        taskFieldEmpty = false
                                    }
                                    else {
                                        taskFieldEmpty = true
                                    }
                                } // End of onChange
                            
                            
                            // Location Text Field
                            TextField("", text: $locationText, prompt: Text("Location Name").font(.system(size: 20, weight: .bold)).foregroundColor(lightGrayColor))
                                .frame(width: 300, height:50)
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(colorLayout), lineWidth: 1.5))
                                .multilineTextAlignment(.center).padding()
                                .padding(-10)
                                .onChange(of: locationText) { // Disables and Enables Done Button
                                    let trimmedLocationTest = locationText.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if trimmedLocationTest != "" {
                                        locationFieldEmpty = false
                                    }
                                    else {
                                        locationFieldEmpty = true
                                    }
                                } // End of onChange
                            
                            HStack {
                                // Picker Label
                                Text("Assigne To")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                                
                                 // Picker
                                Picker("", selection: $assignedTo) {
                                    ForEach(0..<assignOptions.count, id: \.self) { index in
                                        Text(assignOptions[index]).font(.system(size: 20))
                                    } // End of For-Each
                                }.accentColor(.white).onChange(of: assignedTo){print(assignedTo)} // End of Picker
                            } // End of HStack
                            .frame(width: 300, height: 50)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(colorLayout), lineWidth: 1.5))
                        } // End VStack
                    } // End of ZStack
                }
            }
        } // End of ZStack
        .onAppear {
            // Initailizes assignOptions
            assignOptions.append(currentUser)
            for friend in friends {
                if friend.username == currentUser {
                    assignOptions.append(friend.friendUsername)
                }
            } // End of For-Loop
        } // End of onAppear
    } // End of Body
    
    // Creates Taks and Saves it
    func createTask() {
        let taskId = generateID()
        
        let newTask = Tasks(taskID: taskId, listID: listID, assignedUser: assignOptions[assignedTo], latitude: clickedLocation.latitude, longitude: clickedLocation.longitude, radius: circleRadius, completed: false, content: taskText, locationName: locationText)
        context.insert(newTask)
        
    } // End of createTask Function
    
    // generateID Function - Generates Unique ID for Task
    func generateID() -> Int {
        var done = false
        var candidateTaskID = 0
        
        while done == false {
            done = true
            candidateTaskID = Int.random(in: 10000...99999)
            for task in tasks {
                if task.taskID == candidateTaskID {
                    done = false
                }
            }
        } // End of While-Loop
        return candidateTaskID
    } // End of generateID Function
    
    // Adds friend task was assigned to 
    func addFriendToList() {
        for user in users {
            if user.listID == listID && user.username == assignOptions[assignedTo] {
                return
            }
        } // End of For-Loop
        
        let addFriend = User(username: assignOptions[assignedTo], listID: listID)
        context.insert(addFriend)
    } // End of addFriendToList Function
} // End of Struct

#Preview {
    CreateTaskView(listID: 0, colorLayout: .red)
}
