//
//  TasksView.swift
//  JList
//
//  Created by Turing on 12/5/24.
//

import SwiftUI
import MapKit
import SwiftData

struct TasksView: View {
    var listTitle: String
    var titleColor: Color
    var listID: Int
    
    // Show Sheet Variable
    @State private var showingSheet = false
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) var context
    // Tasks Variable
    @Query var tasks: [Tasks]
    
    @State private var listTasks: [Tasks] = []
    
    var body: some View {
        ZStack {
            // Background Color
            Color(backgroundColorGray).ignoresSafeArea(.all)
            
            VStack {
                // My Lists Label
                Text(listTitle)
                    .frame(width: 333, alignment: .leading)
                    .foregroundColor(titleColor)
                    .font(.system(size: 35, weight: .bold))
                
                // Task List
                List($listTasks) { $task in
                    // Cell
                    VStack {
                        // Checkbox and Content
                        HStack {
                            // Checkbox Button
                            Button {
                                task.completed.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    if task.completed == true {
                                        deleteTask(task: task)
                                    }
                                }
                            } label: {
                                Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(task.completed ? titleColor : .white)
                            } // End of Button
                            
                            // Task Content
                            Text(task.content)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }.frame(width: 310, alignment: .leading) // End of HStack
                        
                        // Location
                        Text("Location: \(task.locationName)")
                            .foregroundColor(lightGrayColor)
                            .frame(width: 310, alignment: .leading)
                        // Assigned To
                        Text("Assigned To: \(task.assignedUser)")
                            .foregroundColor(lightGrayColor)
                            .frame(width: 310, alignment: .leading)
                    }.listRowBackground(Color(backgroundColorGray)).listRowSeparatorTint(Color(lightGrayColor)) // End of VStack
                }.listStyle(.inset).scrollContentBackground(.hidden) // End of List
                
                // New Task Button
                Button {
                    showingSheet.toggle()
                } label: {
                    HStack {
                       Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(titleColor)
                        
                        Text("New Task")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(titleColor)
                    } // End of HStack
                }.sheet(isPresented: $showingSheet, onDismiss: {loadListTasks()}) {
                    CreateTaskView(listID: listID, colorLayout: titleColor)
                } // End of Sheet
            } // End of VStack
        } // End of ZStack
        .onAppear {
            loadListTasks()
        } // End of onAppear
    } // End of Body
    
    // Loads Tasks into listTasks
    func loadListTasks() {
        // Iterating through tasks and appending list task to listTaks
        DispatchQueue.main.async {
            for task in tasks {
                // If task.listID is equal to current listID
                if task.listID == listID && listTasks.contains(task) == false {
                    listTasks.append(task)
                }
            }
        }
    } // End of loadListTasks Function
    
    // Deletes Task from listTask and Tasks
    func deleteTask(task: Tasks) {
        // Deletes from Tasks
        context.delete(task)
        
        // Deletes from listTasks with Animation
        withAnimation(.easeInOut(duration: 0.3)) {
            listTasks.removeAll { value in
                value == task
            }
        }
    } // End of deleteTask Function
} // End of Struct

#Preview {
    TasksView(listTitle: "defaultTitle", titleColor: .red, listID: 0)
}
