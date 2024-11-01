//
//  TodoListFireStoreModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 08/10/24.
//

import Foundation

struct ToDoItem {
    var id: String
    var title: String
    var description: String
    var time: String
    var duration: Int
    var status: String
    var userId: String  // Add userId as a String


    init(id: String, title: String, description: String, time: String, duration: Int, status: String, userID: String) {
        self.id = id
        self.title = title
        self.description = description
        self.time = time
        self.duration = duration
        self.status = status
        self.userId = userID
    }

    init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
              let description = dictionary["description"] as? String,
              let time = dictionary["time"] as? String,
              let duration = dictionary["duration"] as? Int,
              let status = dictionary["status"] as? String,
              let id = dictionary["id"] as? String ,
              let userId = dictionary["userId"] as? String else { return nil } // Extract userId


        self.init(id: id, title: title, description: description, time: time, duration: duration, status: status, userID: userId)
    }

    var dictionary: [String: Any] {
        return [
            "title": title,
            "description": description,
            "time": time,
            "duration": duration,
            "status": status,
            "id": id,
            "userId": userId // Include userId in the dictionary
        ]
    }
}

