//
//  Test2.swift
//  JList
//
//  Created by Turing on 12/2/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State var selectedTab: String = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                ZStack {
                    if selectedTab == "person" {
                        ProfileView()
                    } else if selectedTab == "ellipsis.circle" {
                        ListsView()
                    } else if selectedTab == "message" {
                        ChatView()
                    }
                }
                Spacer()
                TabBar(selectedTab: $selectedTab).frame(height: 53)
            }
            .padding()
            .background(Color(backgroundColorGray))
            .ignoresSafeArea()
            .onAppear {
                selectedTab = "ellipsis.circle"
            } // End of onAppear
        }
    }
}

#Preview {
    TabBarView()
}
