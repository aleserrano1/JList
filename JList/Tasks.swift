//
//  Task.swift
//  JList
//
//  Created by Turing on 12/8/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Tasks {
    
    var taskID: Int
    var listID: Int
    var assignedUser: String
    var latitude: Double
    var longitude: Double
    var radius: Double
    var completed: Bool
    var content: String
    var locationName: String
    
    init(taskID: Int, listID: Int, assignedUser: String, latitude: Double, longitude: Double, radius: Double, completed: Bool, content: String, locationName: String) {
        self.taskID = taskID
        self.listID = listID
        self.assignedUser = assignedUser
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.completed = completed
        self.content = content
        self.locationName = locationName
    }
    
}
