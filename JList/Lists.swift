//
//  UserLists.swift
//  JList
//
//  Created by Turing on 12/5/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Lists {
    
    var listID: Int
    var listName: String
    var listColor: String
    var listIcon: String
    
    init(listID: Int, listName: String, listColor: String, listIcon: String) {
        self.listID = listID
        self.listName = listName
        self.listColor = listColor
        self.listIcon = listIcon
    }
    
}






