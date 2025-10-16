//
//  UserFriends.swift
//  JList
//
//  Created by Turing on 12/2/24.
//

import Foundation
import SwiftData

@Model
class UserFriends {
    
    var username: String
    var friendUsername: String
    
    init(username: String, friendUsername: String) {
        self.username = username
        self.friendUsername = friendUsername
    }
}
