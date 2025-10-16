//
//  TextMessages.swift
//  JList
//
//  Created by Turing on 12/8/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class TextMessages {
    
    var username: String
    var listID: Int
    var textContent: String
    
    init(username: String, listID: Int, textContent: String) {
        self.username = username
        self.listID = listID
        self.textContent = textContent
    }
    
}
