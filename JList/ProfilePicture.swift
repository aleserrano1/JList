//
//  ProfilePicture.swift
//  JList
//
//  Created by Turing on 12/9/24.
//

import Foundation
import SwiftData

@Model
class ProfilePicture {
    
    var username: String
    var userPFP: Data
    
    init(username: String, userPFP: Data) {
        self.username = username
        self.userPFP = userPFP
    }
}
