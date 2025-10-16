//
//  MessageView.swift
//  JList
//
//  Created by Turing on 12/8/24.
//

import SwiftUI
import SwiftData

struct MessageView: View {
    var listID: Int
    var colorLayout: String
    var chatName: String
    var chatIcon: String
    
    // Message Input Variable
    @State private var messageInput = ""
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) var context
    // Accounts Variable
    @Query var messages: [TextMessages]
    
    var body: some View {
        ZStack {
            // Background Color
            Color(backgroundColorGray).ignoresSafeArea(.all)
            
            VStack {
                // Title and Icon
                HStack {
                    // Icon
                    Image(systemName: chatIcon)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .background(Color(stringToColor(strColor: colorLayout)))
                        .foregroundColor(.white)
                        .bold()
                    // Title
                    Text(chatName)
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                }.frame(width: 400, height: 100, alignment: .center).background(Color(stringToColor(strColor: colorLayout))) // End of HStack
                    
                // Messages
                ScrollView {
                    VStack() {
                        ForEach(messages, id: \.self) { message in
                            if message.listID == listID {
                                if message.username == currentUser {
                                    VStack {
                                        HStack() {
                                            Spacer()
                                            Text(message.textContent)
                                                .padding(12)
                                                .foregroundColor(.white)
                                                .background(Color(stringToColor(strColor: colorLayout)))
                                                .cornerRadius(20)
                                                .shadow(radius: 5)
                                        } // End of HStack
                                        HStack {
                                            Spacer()
                                            Text(message.username)
                                                .foregroundColor(lightGrayColor)
                                                .padding(-7)
                                        } // End of HStack
                                    }.padding(10) // End of VStack
                                } else {
                                    VStack {
                                        HStack {
                                            Text(message.textContent)
                                                .padding(12)
                                                .foregroundColor(.white)
                                                .background(Color(foregroundColorGray))
                                                .cornerRadius(20)
                                                .shadow(radius: 5)
                                            Spacer()
                                        }// End of HStack
                                        HStack {
                                            Text(message.username)
                                                .foregroundColor(lightGrayColor)
                                                .padding(-7)
                                            Spacer()
                                        } // End of HStack
                                    }.padding(10) // End of VStack
                                        
                                }
                            } // End of If-Statement
                        } // End of ForEach
                    } // End of VStack
                }.frame(height: 520).padding(25) // End of ScrollView
            
                // Message Text Field and Send Button
                ZStack {
                    Rectangle()
                        .frame(width: 400, height: 100)
                        .foregroundColor(foregroundColorGray)
                    
                    HStack {
                        // Text Field for Message Input
                        TextField("", text: $messageInput, prompt: Text("Message").foregroundColor(lightGrayColor)).frame(width: 220, alignment: .leading)
                            .frame(width: 300, height:50)
                            .background(Color(backgroundColorGray))
                            .foregroundColor(.white)
                        .cornerRadius(30)
                        
                        Button {
                            createNewMessage()
                            messageInput = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .frame(width: 40, height: 40)
                                .background(Color(backgroundColorGray))
                                .foregroundColor(stringToColor(strColor: colorLayout))
                                .bold()
                                .clipShape(Circle())
                                .padding(10)
                        } // End of Button
                    } // End of HStack
                } // End of ZStack
            } //End of VStack
        } // End of ZStack
    } // End of Body
    
    // Creates New Message and saves it
    func createNewMessage() {
        let newMessage = TextMessages(username: currentUser, listID: listID, textContent: messageInput)
        context.insert(newMessage)
        
        print(newMessage.textContent)
        print(newMessage.listID)
        print(listID)
    } // End of createNewMessage
    
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
}

#Preview {
    MessageView(listID: 0, colorLayout: "redColor", chatName: "To-Do", chatIcon: "cube.fill")
}
