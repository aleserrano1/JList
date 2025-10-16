//
//  ListsView.swift
//  JList
//
//  Created by Turing on 11/20/24.
//

import SwiftUI
import SwiftData

struct ListsView: View {
    
    // Show Sheet Variable
    @State private var showingSheet = false
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) var context
    // Lists Variable
    @Query var lists: [Lists]
    // User Variable
    @Query var user: [User]
    
    // Current User Lists Avaliable
    @State private var currentUserList: [Int] = []
    
    // View Dismiss Variable
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        //NavigationStack {
            ZStack {
                Color(backgroundColorGray).ignoresSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        // Log Out Button
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                                .bold()
                                .foregroundColor(greenColor)
                                .padding(.horizontal)
                        } // End of Button
                    }
                    // My Lists Label
                    Text("My Lists")
                        .frame(width: 333, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .bold))
                    
                    // List for User Lists
                    List {
                        ForEach(lists, id: \.self) { list in
                            if currentUserList.contains(list.listID) {
                                let listColor = stringToColor(strColor: list.listColor)
                                NavigationLink(destination: TasksView(listTitle: list.listName, titleColor: listColor, listID: list.listID), label: {
                                    HStack {
                                        Image(systemName: list.listIcon)
                                            .frame(width: 40, height: 40)
                                            .background(Color(listColor))
                                            .foregroundColor(.white)
                                            .bold()
                                            .clipShape(Circle())
                                        Text(list.listName)
                                            .font(.system(size: 25))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                    } // End of HStack
                                }).listRowBackground(Color(foregroundColorGray))
                            } // End of If-Statement
                        } // End of ForEach
                    }.listStyle(.automatic).scrollContentBackground(.hidden).frame(height: 460)
                        .padding(.top, -20)// End of List
                    
                    // Add Button
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                            .frame(width: 60, height: 60)
                            .background(Color(greenColor))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding() // End of Add Button
                    .sheet(isPresented: $showingSheet, onDismiss: {loadUserList()}) {
                        CreateListView()
                    } // End of Sheet
                    
                }
            }.navigationBarBackButtonHidden(true) // End of ZStack
            .onAppear {
                DispatchQueue.main.async {
                    loadUserList()
                }
            }
        //} // End of Navigation Stack
    } // End of Body
    
    // Function to convert string color to type Color
    func stringToColor(strColor: String) -> Color {
        var color: Color = backgroundColorGray
        
        if strColor == "redColor" {
            color = redColor
        } else if strColor == "orangeColor" {
            color = orangeColor
        } else if strColor == "yellowColor" {
            color = yellowColor
        } else if strColor == "greenColor" {
            color = greenColor
        } else if strColor == "blueColor" {
            color = blueColor
        }
        
        return color
    } // End of stringToColor Function
    
    func loadUserList() {
        // Moves all current user lists to array
        for userList in user {
            if userList.username == currentUser {
                currentUserList.append(userList.listID)
            }
        }
    }
} // End of Struct

#Preview {
    ListsView()
}
