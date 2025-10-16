//
//  SignUpView.swift
//  JList
//
//  Created by Turing on 11/20/24.
//

import SwiftUI
import SwiftData

// Enumeration for Alerts
enum ActiveAlert {
    case signUpError, usernameTaken, accountCreated
}

struct SignUpView: View {
    
    // Current State Color Varibale
    @State var currentColor: Color = yellowColor
    
    // Show Alert Variable
    @State private var showAlert = false
    // What Alert is Active Variable
    @State private var activeAlert: ActiveAlert = .signUpError
    
    // NewUsername and  NewPassword Variables
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    // View Dismiss Variable
    @Environment(\.dismiss) var dismiss
    
    // Credentials Data Context Variable
    @Environment(\.modelContext) var context
    // Accounts Variable
    @Query var accounts: [UserCredentials]
    // User PFPs Variable
    @Query var userPFPs: [ProfilePicture]
    
    
    var body: some View {
        ZStack {
            // Background Color
            Color(backgroundColorGray).ignoresSafeArea(.all)
            
            VStack {
                // Flame Icon
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(greenColor).opacity(0.4))
                        
                        Image(systemName: "flame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(greenColor))
                    } // End of ZStack
                }.frame(width: 320, alignment: .leading).padding() // End of HStack
                
                // Create Account and Sub Label
                VStack {
                    // Create Account Label
                    Text("Create Account")
                        .frame(width: 320, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .bold))
                    
                    // Sub Label
                    Text("...and give your \(Text("brain").italic()) a break!")
                        .frame(width: 320, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }.padding() // End of VStack
                
                
                // Sign Up Form
                ZStack {
                    VStack {
                        // Username Text Field and User Icon
                        HStack {
                            // User Icon
                            Image(systemName: "person.fill")
                                .frame(width: 50, height: 50)
                                .background(Color(currentColor).opacity(0.4))
                                .foregroundColor(currentColor)
                                .cornerRadius(5)
                            
                            // Username Text Field
                            TextField("", text: $newUsername, prompt: Text("Username").foregroundColor(.gray))
                                .frame(width: 250, height:50)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(currentColor), lineWidth: 1.5))
                        }.frame(width: 320, alignment: .leading) // End of HStack
                        
                        // Password Text Field and Lock Icon
                        HStack {
                            // Lock Icon
                            Image(systemName: "lock.fill")
                                .frame(width: 50, height: 50)
                                .background(Color(currentColor).opacity(0.4))
                                .foregroundColor(currentColor)
                                .cornerRadius(5)
                            
                            TextField("", text: $newPassword, prompt: Text("Password").foregroundColor(.gray))
                                .frame(width: 250, height:50)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(currentColor), lineWidth: 1.5))
                        }.frame(width: 320, alignment: .leading).padding() // End of HStack
                        
                        // Confirm Password Text Field and Lock Icon
                        HStack {
                            // Lock Icon
                            Image(systemName: "lock.fill")
                                .frame(width: 50, height: 50)
                                .background(Color(currentColor).opacity(0.4))
                                .foregroundColor(currentColor)
                                .cornerRadius(5)
                            
                            TextField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.gray))
                                .frame(width: 250, height:50)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(currentColor), lineWidth: 1.5))
                        }.frame(width: 320, alignment: .leading) // End of HStack
                    } // End of VStack
                }.padding(40) // End of ZStack
                
                HStack {
                    // Back Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                        .bold()
                        .frame(width: 55, height: 55)
                        .background(Color(greenColor).opacity(0.4))
                        .foregroundColor(greenColor)
                        .cornerRadius(10)
                    } // End of Back Button
                    
                    // Sign Up Button with Alerts
                    Button {
                        createAccount()
                    } label: {
                        Text("Sign Up")
                            .bold()
                            .frame(width: 250, height: 55)
                            .background(Color(greenColor))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.alert(isPresented: $showAlert) {
                        switch activeAlert {
                        case .signUpError:
                            return Alert(title: Text("Sign Up Error"), message: Text("Make sure all fields are filled in and Password matches Confirm Password."))
                        case .usernameTaken:
                            return Alert(title: Text("Username Taken"), message: Text("The Username is already taken. Please choose a differnt one."))
                        case .accountCreated:
                            return Alert(title: Text("Account Created"), message: Text(""))
                        } // End of activeAlert Case
                    } // End of Sign Up Button and End of Alert
        
                } // End of HStack
                
            } // End of VStack
        }.navigationBarBackButtonHidden(true) // End of ZStack
    } // End of Body
    
    
    // Create Account Function
    func createAccount() {
        // Gets first letter of newUsername and sets it to defualt
        /*var defaultIcon: String = ""
        if let firstLetter = newUsername.first {
            defaultIcon = String(firstLetter)
        }*/
        
        // usernameTaken Boolean
        var usernameTaken: Bool = false
        
        // If newUsername and newPassword are not blank; Move on
        if newUsername.trimmingCharacters(in: .whitespaces) != "" && newPassword.trimmingCharacters(in: .whitespaces) != "" {
            
            // If newPassword equals confirmPassword; Move on
            if newPassword == confirmPassword {
                
                // Checks if newUsername is taken
                usernameTaken = accounts.contains{$0.username.lowercased() == newUsername.lowercased()}
                
                // If newUsername is not taken; Create Account and Change currentColor and Clear Fields
                if usernameTaken == false {
                    // Create newAccount
                    let newAccount = UserCredentials(username: newUsername, password: newPassword)
                    context.insert(newAccount)
                    
                    // Create Defualt PFP
                    let uiImage = UIImage(systemName: "person.crop.circle")!
                    var imageData = Data()
                    // Convert the UIImage to PNG or JPEG data
                    if let data = uiImage.pngData() {
                        imageData = data
                    }
                    let userPFP = ProfilePicture(username: newUsername, userPFP: imageData)
                    context.insert(userPFP)

                    currentColor = greenColor
                    
                    newUsername = ""
                    newPassword = ""
                    confirmPassword = ""
                    
                    activeAlert = .accountCreated
                    showAlert.toggle()
                    return
                }
            }
        }
        
        // Show Correct Alert and Change currentColor
        if usernameTaken == true {
            activeAlert = .usernameTaken
        }
        else {
            activeAlert = .signUpError
        }
        currentColor = redColor
        showAlert.toggle()
        print("Account not created")
    }
    
} // End of Struct

#Preview {
    SignUpView()
}
