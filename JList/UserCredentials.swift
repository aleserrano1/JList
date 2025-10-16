//
//  UserCredentials.swift
//  JList
//
//  Created by Turing on 12/9/24.
//

import Foundation
import SwiftData

@Model
class UserCredentials {
    
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
