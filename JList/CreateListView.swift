//
//  CreateListView.swift
//  JList
//
//  Created by Turing on 12/3/24.
//

import SwiftUI
import SwiftData

struct CreateListView: View {
    let sfSymbols_Row1 = ["list.bullet", "folder.fill", "archivebox.fill", "doc.fill", "book.fill"]
    let sfSymbols_Row2 = ["bookmark.fill", "house.fill", "person.fill", "heart.fill", "star.fill"]
    let sfSymbols_Row3 = ["bell.fill", "tag.fill", "icloud.fill", "moon.fill", "bubble.left.fill"]
    let sfSymbols_Row4 = ["envelope.fill", "creditcard.fill", "lock.fill", "alarm.fill", "lightbulb.fill"]
    let sfSymbols_Row5 = ["flame.fill", "hourglass", "shield.lefthalf.fill", "gift.fill", "cube.fill"]
    
    // List Name Variable
    @State private var newListName: String = ""
    
    // Selected Button Variable
    @State private var selectedButton: Int = 1
    
    // Current List Color Variable
    @State private var currentListColor: Color = redColor
    
    // Current List Icon Variable
    @State private var currentListIcon: String = "list.bullet"
    
    // Dismiss Variable
    @Environment(\.dismiss) var dismiss
    
    // Done is Disabled Variable
    @State private var doneDisabled = true
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) var context
    // Lists Variable
    @Query var lists: [Lists]
    // Users Variable
    @Query var users: [User]
    
    var body: some View {
        ZStack {
            Color(backgroundColorGray).ignoresSafeArea(.all)
            VStack {
                HStack {
                    // Cancel Button
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 20))
                        
                    } // End of Button
                    
                    // New List Label
                    Text("New List")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(70)
                    
                    // Done Button
                    Button {
                        createList()
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 20, weight: .bold))
                    }.disabled(doneDisabled) // End of Button
                }.padding(-50) // End of HStack
                
                // List Icon and Text Field
                ZStack {
                    // Background Rectangle
                    RoundedRectangle(cornerRadius: 15.0)
                        .frame(width: 350 ,height: 240)
                        .foregroundColor(foregroundColorGray)
                    
                    VStack {
                        // List Icon
                        Image(systemName: currentListIcon)
                            .font(.system(size: 50, weight: .bold))
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color(currentListColor))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        
                        // List Text Field
                        TextField("", text: $newListName, prompt: Text("List Name").font(.system(size: 25, weight: .bold)).foregroundColor(lightGrayColor))
                            .frame(width: 300, height:60)
                            .foregroundColor(currentListColor)
                            .cornerRadius(5)
                            .font(.system(size: 25, weight: .bold))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(currentListColor), lineWidth: 1.5))
                            .multilineTextAlignment(.center).padding()
                            .onChange(of: newListName) { // Disables and Enables Done Button
                                let trimmedListName = newListName.trimmingCharacters(in: .whitespacesAndNewlines)
                                if trimmedListName != "" {
                                    doneDisabled = false
                                }
                                else {
                                    doneDisabled = true
                                }
                            } // End of onChange
                    } // End VStack
                } // End of ZStack
                
                // Color Picker
                ZStack {
                    // Background Rectangle
                    RoundedRectangle(cornerRadius: 15.0)
                        .frame(width: 350 ,height: 70)
                        .foregroundColor(foregroundColorGray)
                    
                    // Color Buttons
                    HStack {
                        // Red Button
                        Button {
                            selectedButton = 1
                            currentListColor = redColor
                        } label: {
                            Image("")
                                .frame(width: 40, height: 40)
                                .background(Color(redColor))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedButton == 1 ? Color(lightGrayColor) : Color.clear, lineWidth: 2)
                                ).animation(.spring(), value: selectedButton)
                        }.padding(8) // End of Button
                        
                        
                        // Orange Button
                        Button {
                            selectedButton = 2
                            currentListColor = orangeColor
                        } label: {
                            Image("")
                                .frame(width: 40, height: 40)
                                .background(Color(orangeColor))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedButton == 2 ? Color(lightGrayColor) : Color.clear, lineWidth: 2)
                                ).animation(.spring(), value: selectedButton)
                        }.padding(8) // End of Button
                        
                        // Yellow Button
                        Button {
                            selectedButton = 3
                            currentListColor = yellowColor
                        } label: {
                            Image("")
                                .frame(width: 40, height: 40)
                                .background(Color(yellowColor))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedButton == 3 ? Color(lightGrayColor) : Color.clear, lineWidth: 2)
                                ).animation(.spring(), value: selectedButton)
                        }.padding(8) // End of Button
                        
                        // Green Button
                        Button {
                            selectedButton = 4
                            currentListColor = greenColor
                        } label: {
                            Image("")
                                .frame(width: 40, height: 40)
                                .background(Color(greenColor))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedButton == 4 ? Color(lightGrayColor) : Color.clear, lineWidth: 2)
                                ).animation(.spring(), value: selectedButton)
                        }.padding(8) // End of Button
                        
                        // Blue Button
                        Button {
                            selectedButton = 5
                            currentListColor = blueColor
                        } label: {
                            Image("")
                                .frame(width: 40, height: 40)
                                .background(Color(blueColor))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedButton == 5 ? Color(lightGrayColor) : Color.clear, lineWidth: 2)
                                ).animation(.spring(), value: selectedButton)
                        }.padding(8) // End of Button
                    } // End of HStack
                } // End of ZStack
                
                // Icon Picker
                ZStack {
                    // Background Rectangle
                    RoundedRectangle(cornerRadius: 15.0)
                        .frame(width: 350 ,height: 320)
                        .foregroundColor(foregroundColorGray)
                    
                    // Icon Rows
                    VStack {
                        // Icon Buttons - Row 1
                        HStack {
                            ForEach(sfSymbols_Row1, id: \.self) {symbol in
                                Button {
                                    currentListIcon = symbol
                                } label: {
                                    Image(systemName: symbol)
                                        .frame(width: 40, height: 40)
                                        .background(Color(backgroundColorGray))
                                        .foregroundColor(.white)
                                        .bold()
                                        .clipShape(Circle())
                                }.padding(8) // End of Button
                            } // End of ForEach
                        } // End of HStack
                        
                        // Icon Buttons - Row 2
                        HStack {
                            ForEach(sfSymbols_Row2, id: \.self) {symbol in
                                Button {
                                    currentListIcon = symbol
                                } label: {
                                    Image(systemName: symbol)
                                        .frame(width: 40, height: 40)
                                        .background(Color(backgroundColorGray))
                                        .foregroundColor(.white)
                                        .bold()
                                        .clipShape(Circle())
                                }.padding(8) // End of Button
                            } // End of ForEach
                        } // End of HStack
                        
                        // Icon Buttons - Row 3
                        HStack {
                            ForEach(sfSymbols_Row3, id: \.self) {symbol in
                                Button {
                                    currentListIcon = symbol
                                } label: {
                                    Image(systemName: symbol)
                                        .frame(width: 40, height: 40)
                                        .background(Color(backgroundColorGray))
                                        .foregroundColor(.white)
                                        .bold()
                                        .clipShape(Circle())
                                }.padding(8) // End of Button
                            } // End of ForEach
                        } // End of HStack
                        
                        // Icon Buttons - Row 4
                        HStack {
                            ForEach(sfSymbols_Row4, id: \.self) {symbol in
                                Button {
                                    currentListIcon = symbol
                                } label: {
                                    Image(systemName: symbol)
                                        .frame(width: 40, height: 40)
                                        .background(Color(backgroundColorGray))
                                        .foregroundColor(.white)
                                        .bold()
                                        .clipShape(Circle())
                                }.padding(8) // End of Button
                            } // End of ForEach
                        } // End of HStack
                        
                        // Icon Buttons - Row 5
                        HStack {
                            ForEach(sfSymbols_Row5, id: \.self) {symbol in
                                Button {
                                    currentListIcon = symbol
                                } label: {
                                    Image(systemName: symbol)
                                        .frame(width: 40, height: 40)
                                        .background(Color(backgroundColorGray))
                                        .foregroundColor(.white)
                                        .bold()
                                        .clipShape(Circle())
                                }.padding(8) // End of Button
                            } // End of ForEach
                        } // End of HStack
                    } // End of VStack
                } // End of ZStack
                
            }
        }
    }
    
    // Creates a New List
    func createList() {
        let listID = generateID()
        
        var strListColor = ""
        if currentListColor == redColor {
            strListColor = "redColor"
        } else if currentListColor == orangeColor {
            strListColor = "orangeColor"
        } else if currentListColor == yellowColor {
            strListColor = "yellowColor"
        } else if currentListColor == greenColor {
            strListColor = "greenColor"
        } else if currentListColor == blueColor {
            strListColor = "blueColor"
        }
        
        // Creates new list
        let newList = Lists(listID: listID, listName: newListName, listColor: strListColor, listIcon: currentListIcon)
        context.insert(newList)
        
        // Assigns User new list
        let user = User(username: currentUser, listID: listID)
        context.insert(user)
    }
    
    // generateID Function - Generates Unique ID for List
    func generateID() -> Int {
        var done = false
        var listID = 0
        
        while done == false {
            done = true
            listID = Int.random(in: 10000...99999)
            for list in lists {
                if list.listID == listID {
                    done = false
                }
            }
        } // End of While-Loop
        return listID
    } // End of generateID Function
}

#Preview {
    CreateListView()
}
