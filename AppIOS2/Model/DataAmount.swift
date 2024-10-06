//
//  DataAmount.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//

import Foundation
class DataAmount{
    var account: String
    var curr:String
    var blance:Double
    
    init(account: String, curr: String, blance: Double) {
        self.account = account
        self.curr = curr
        self.blance = blance
    }
}
