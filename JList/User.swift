//
//  User.swift
//  JList
//
//  Created by Turing on 12/7/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class User {
    
    var username: String
    var listID: Int
    
    init(username: String, listID: Int) {
        self.username = username
        self.listID = listID
    }
    
}
