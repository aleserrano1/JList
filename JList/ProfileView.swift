//
//  ProfileView.swift
//  JList
//
//  Created by Turing on 11/25/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ProfileView: View {
    
    // State Variable for Alert
    @State private var showFriendSearch = false
    
    // State Variable for Friend Username Add
    @State private var inputUsername = ""
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) private var context
    // Accounts Variable
    @Query var accounts: [UserCredentials]
    // Friends Variable
    @Query var friends: [UserFriends]
    // User PFPs Variable
    @Query var userPFPs: [ProfilePicture]
    
    @State private var selectedImage: Image? // Holds the currently selected image
    @State private var photoPickerPresented = false // Controls whether the PhotosPicker is shown
    @State private var photoPickerItem: PhotosPickerItem? // Holds the selected photo item
    
    var body: some View {
        ZStack {
            // Background Color
            Color(backgroundColorGray).ignoresSafeArea(.all)
            
            VStack {
                // Title and Add Button
                HStack {
                    // My Friends Label
                    Text("My Friends")
                        .frame(width: 293, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .bold))
                    
                    // Add Friends Button
                    Button {
                        showFriendSearch.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(redColor)
                    } // End of Button
                } // End of HStack
                
                // User Information
                HStack {
                    // Profile Picture Temp
                    if let selectedImage = selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .padding()
                            .onTapGesture {
                                photoPickerPresented = true
                            }
                    }
                    // Profile Picture
                    /*Text("👶🏽") // <- Make this chooseable
                        .frame(width: 70, height: 70)
                        .font(.system(size: 30))
                        .bold() // For Letters
                        .foregroundColor(.white) // For Letters
                        .background(Color(redColor))
                        .clipShape(Circle())*/
                    
                    // Username
                    Text("\(currentUser)")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 250 ,alignment: .leading) // End of HStack
                }// End of HStack
                .frame(width: 400, height: 120)
                .background(Color(foregroundColorGray))
                .border(Color(lightGrayColor), width: 0.5)
                .padding(.bottom, 25) // <-- After it's Temp
                .photosPicker(isPresented: $photoPickerPresented, selection: $photoPickerItem, matching: .images)
                .onChange(of: photoPickerItem) { newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                            
                            for userPfp in userPFPs {
                                if userPfp.username == currentUser {
                                    userPfp.userPFP = data
                                    print("saved")
                                    try context.save()
                                }
                            }
                        }
                    } // End of Task
                } // End of onChange
              
                
                // Friend List
                List{
                    // For each currentUser friend
                    ForEach(friends, id: \.self) {friend in
                        if friend.username == currentUser {
                            ForEach(userPFPs, id: \.self) { userPfp in
                                if userPfp.username == friend.friendUsername {
                                    let uiimage = UIImage(data: userPfp.userPFP)
                                    
                                    // List Cell
                                    HStack {
                                        Image(uiImage: uiimage!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                            .padding(5)
                                        Text(friend.friendUsername).listRowBackground(Color(foregroundColorGray))
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                    .listRowBackground(Color(foregroundColorGray))
                                    .listRowSeparatorTint(Color(lightGrayColor))
                                }
                            }
                        }
                    }
                }.listStyle(.plain).frame(height: 380) // End of List
                
            } // End of VStack
            .alert("Add Friends", isPresented: $showFriendSearch) {
                    TextField("Enter Username", text: $inputUsername)
                    Button("Add", action: addFriend)
            } message: {
                Text("Enter Friend's Username")
            } // End of Alert
        }.navigationBarBackButtonHidden(true) // End of ZStack
            .onAppear {
                DispatchQueue.main.async {
                    for userPfp in userPFPs {
                        if userPfp.username == currentUser {
                            let uiimage = UIImage(data: userPfp.userPFP)
                            selectedImage = Image(uiImage: uiimage!)
                        }
                    }
                }
            } // End of onAppear
    } // End of Body
    
    
    // Add Friend Function
    func addFriend() {
        // Already Friends Variable
        var alreadyFriends: Bool = false
        
        for friend in friends {
            if friend.username == currentUser {
            }
        }
        
        // For every account in accounts
        for account in accounts {
            // If account equals inputed username and acount is not the current acount
            if account.username == inputUsername && account.username != currentUser {
                
                // Iterates through currentUser friends and compares inputUsername
                for friend in friends {
                    if friend.username == currentUser {
                        if friend.friendUsername == inputUsername {
                            alreadyFriends = true
                        }
                    }
                }
                if alreadyFriends == false {
                    
                    // Add newFriend to UserFriends
                    let newFriend = UserFriends(username: currentUser, friendUsername: inputUsername)
                    context.insert(newFriend)
                    
                    // Add currentUser to Friend's UserFriends
                    let addCurrentUser = UserFriends(username: inputUsername, friendUsername: currentUser)
                    context.insert(addCurrentUser)
                    
                    // Clears inputUsername text field
                    inputUsername = ""
                    return
                }
            }
        }
        // Clears inputUsername text field
        inputUsername = ""
    } // End of addFriend Function
    
    
}

#Preview {
    ProfileView()
}
