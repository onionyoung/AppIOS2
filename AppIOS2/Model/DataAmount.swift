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
    var blance:Float
    
    init(account: String, curr: String, blance: Float) {
        self.account = account
        self.curr = curr
        self.blance = blance
    }
}
