//
//  DataAmountViewModel.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//

import UIKit
class DataNotificationViewModel{
    var datas:[DataNotification] = [DataNotification]()
    
    var showLoading:(()->())?
    var hideLoading:(()->())?
    var showError:(()->())?
    var reloadData:(()->())?
    var requestIsFinish = true
    var requestURLEmpty:URL? = URL(string:"https://willywu0201.github.io/data/emptyNotificationList.json") ?? nil
    var requestURLNotEmpty: URL? = URL(string: "https://willywu0201.github.io/data/notificationList.json") ?? nil
    var hasNewNotification = false;
    func getData(mode:Int){
        self.requestIsFinish = false
        showLoading?()
        var url:URL? = nil
        datas = [DataNotification]()
        if(mode == 1){
            url = requestURLEmpty!
        } else if(mode == 2){
            url = requestURLNotEmpty!
        }
        ApiClient.getDataFromServer(url: url!){ (success, data) in
            if success{
                do{
                    let object = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    
                    //因不知道msgCode對應代號，先以文字判斷訊息狀態
                    let msgContent = object?["msgCode"] as! String
                    if(msgContent == "0000"){
                        let result = object?["result"] as? [String:Any] ?? [:]
                        let List = result["messages"] as? [[String:Any]] ?? []
                        self.setResponseToData(jsonArray: List)
                    }else{
                        self.requestIsFinish = true
                        self.showError?()
                    }
                }
                catch{
                    self.requestIsFinish = true
                    self.showError?()
                }
            }else{
                self.requestIsFinish = true
                self.showError?()
            }
        }
    }
    
    func setResponseToData(jsonArray:[[String:Any]]){
        for json in jsonArray{
            let status = json["status"] as? Bool ?? false
            let updateDateTimeString = json["updateDateTime"] as? String ?? ""
            let title = json["title"] as? String ?? ""
            let message = json["message"] as? String ?? ""
            
            if(!status){
                hasNewNotification = true
            }
            
            //檢查資料合格性
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            var updateDateTime = dateFormatter.date(from: updateDateTimeString)
            
            if(updateDateTime == nil){
                dateFormatter.dateFormat = "HH:mm:ss yyyy/MM/dd"
                updateDateTime = dateFormatter.date(from: updateDateTimeString)
                if(updateDateTime == nil){
                    continue
                }
            }
            //寫入資料
            let item = DataNotification(status: status, updateDateTime: updateDateTime!, title: title, message: message)
            self.datas.append(item)
        }
        self.requestIsFinish = true
        reloadData?()
        hideLoading?()
    }
}
