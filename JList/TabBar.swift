//
//  Test.swift
//  JList
//
//  Created by Turing on 12/2/24.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var selectedTab: String
    
    var body: some View {
        // Tab Bar
        HStack {
            // Tabs
            TabsView(image: "person", selectedTab: $selectedTab)
            TabsView(image: "ellipsis.circle", selectedTab: $selectedTab)
            TabsView(image: "message", selectedTab: $selectedTab)
        }
        .frame(width: 360)
        .accentColor(greenColor)
        .padding()
        .background(Color(foregroundColorGray))
        .cornerRadius(25)
        .padding(.horizontal)
    } // End of Body
} // End of Struct

#Preview {
    TabBarView()
}

struct TabsView: View {
    
    let image: String
    @Binding var selectedTab: String
    var body: some View {
        GeometryReader { button in
            Button {
                withAnimation(.linear(duration: 0.3)) {
                    selectedTab = image
                }
            } label: {
                VStack {
                    Image(systemName: "\(image)\(selectedTab == image ? ".fill" : "")")
                        .offset(y: selectedTab == image ? -5 : 0)
                        .scaleEffect(selectedTab == image ? 1.2 : 1.0)
                        .foregroundColor(selectedTab == image ? .accentColor : Color(redColor))
                    
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 20, height: 2)
                        .opacity(selectedTab == image ? 1.0 : 0.0)
                        .padding(.top, 1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 50)
    }
}

