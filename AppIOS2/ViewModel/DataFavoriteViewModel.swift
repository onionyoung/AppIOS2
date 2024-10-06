//
//  DataFavoriteViewModel.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//

import UIKit
class DataFavoriteViewModel{
    var datas:[DataFavorite] = [DataFavorite]()
    
    var showLoading:(()->())?
    var hideLoading:(()->())?
    var showError:(()->())?
    var reloadData:(()->())?
    var requestURLEmpty:URL? = URL(string:"https://willywu0201.github.io/data/emptyFavoriteList.json") ?? nil
    var requestURLNotEmpty: URL? = URL(string: "https://willywu0201.github.io/data/favoriteList.json") ?? nil
    var requestIsFinish = true
    
    func getData(mode:Int){
        self.requestIsFinish = false
        showLoading?()
        var url:URL? = nil
        datas = [DataFavorite]()
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
                        let List = result["favoriteList"] as? [[String:Any]] ?? []
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
            let nickname = json["nickname"] as? String ?? ""
            let transType = json["transType"] as? String ?? ""
            //檢查資料合格性
            
            //寫入資料
            let item = DataFavorite(nickname: nickname, transType: transType)
            self.datas.append(item)
        }
        self.requestIsFinish = true
        reloadData?()
        hideLoading?()
    }
}
