//
//  ChatView.swift
//  JList
//
//  Created by Turing on 11/25/24.
//

import SwiftUI
import SwiftData

struct ChatView: View {
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) var context
    // User Variable
    @Query var users: [User]
    // Lists Variables
    @Query var lists: [Lists]
    
    // Current User Lists Avaliable
    @State private var currentUserList: [Int] = []
    
    var body: some View {
        ZStack {
            Color(backgroundColorGray).ignoresSafeArea(.all)
            VStack {
                // Message Label
                Text("Message")
                    .frame(width: 333, alignment: .leading)
                    .foregroundColor(.white)
                    .font(.system(size: 35, weight: .bold))
                
                // List
                List {
                    ForEach(lists, id: \.self) { list in
                        if currentUserList.contains(list.listID) {
                            let listColor = stringToColor(strColor: list.listColor)
                            NavigationLink(destination: MessageView(listID: list.listID, colorLayout: list.listColor, chatName: list.listName, chatIcon: list.listIcon), label: {
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
                            }).listRowBackground(Color(backgroundColorGray))
                        } // End of If-Statement
                    } // End of ForEach
                }.listStyle(.inset).scrollContentBackground(.hidden).frame(height: 550)
                    .padding(.top, -20) // End of List
            }
        }.navigationBarBackButtonHidden(true) // End of ZStack
        .onAppear {
            DispatchQueue.main.async {
                loadUserList()
            }
        } // End of onAppear
    } // End of Body
    
    // Loads all users listID to currentUserList
    func loadUserList() {
        // Moves all current user lists to array
        for userList in users {
            if userList.username == currentUser {
                currentUserList.append(userList.listID)
            }
        }
    } // End of loadUserList Function
    
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
} // End of Struct

#Preview {
    ChatView()
}
