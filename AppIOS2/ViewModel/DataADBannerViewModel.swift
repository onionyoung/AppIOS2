//
//  DataADBannerViewModel.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//
import UIKit
class DataADBannerViewModel{
    var datas:[DataADBanner] = [DataADBanner]()
    
    var showLoading:(()->())?
    var hideLoading:(()->())?
    var showError:(()->())?
    var requestURL:URL? = URL(string:"https://willywu0201.github.io/data/banner.json") ?? nil
    func getData(){
        showLoading?()
        ApiClient.getDataFromServer(url: requestURL!){ (success, data) in
            if success{
                do{
                    let object = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    //let jsonArray = object?["response"] as! [String:Any]
                    //因不知道msgCode對應代號，先以文字判斷訊息狀態
                    let msgContent = object?["msgCode"] as! String
                    if(msgContent == "0000"){
                        let result = object?["result"] as? [String:Any] ?? [:]
                        let List = result["bannerList"] as? [[String:Any]] ?? []
                        self.setResponseToData(jsonArray: List)
                    }else{
                        self.showError?()
                    }
                }
                catch{
                    self.showError?()
                }
            }else{
                self.showError?()
            }
        }
    }
    
    func setResponseToData(jsonArray:[[String:Any]]){
        for json in jsonArray{
            let adSeqNo = json["adSeqNo"] as? Int ?? -1
            let linkUrl = json["linkUrl"] as? String ?? ""
            //檢查資料合格性
            
            //寫入資料
            let item = DataADBanner(adSeqNo: adSeqNo, linkUrl: linkUrl)
            self.datas.append(item)
        }
        hideLoading?()
    }
}
