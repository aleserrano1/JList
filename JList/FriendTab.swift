//
//  FriendTab.swift
//  JList
//
//  Created by Turing on 12/2/24.
//

import SwiftUI

struct FriendTab: View {
    
    var friendUsername: String
    
    var body: some View {
        HStack {
            // Profile Picture
            Text("👶🏽")
                .frame(width: 70, height: 70)
                .font(.system(size: 30))
                .bold()
                .foregroundColor(.white)
                .background(Color(redColor))
                .clipShape(Circle())
            
            // Username
            Text("\(friendUsername)")
                .frame(width: 150, alignment: .leading)
                .foregroundColor(.white)
                .font(.system(size: 25, weight: .bold))
            
        } // End of VStack
    }
}

#Preview {
    FriendTab(friendUsername: "null")
}
