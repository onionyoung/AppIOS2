//
//  DataNotification.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//

import Foundation

class DataNotification{
    var status:Bool
    var updateDateTime:Date
    var title:String
    var message:String
    
    init(status: Bool, updateDateTime: Date, title: String, message: String) {
        self.status = status
        self.updateDateTime = updateDateTime
        self.title = title
        self.message = message
    }
}
