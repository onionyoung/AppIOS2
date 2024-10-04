//
//  DataKHRAmountViewModel.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//


import UIKit
class DataKHRAmountViewModel{
    var datasSaving:[DataAmount] = [DataAmount]()
    var datasFixedDeposited:[DataAmount] = [DataAmount]()
    var datasDigital:[DataAmount] = [DataAmount]()
    
    var showLoading:(()->())?
    var hideLoading:(()->())?
    var showError:(()->())?
    //first open
    var requestURLSaving:URL? = URL(string:"https://willywu0201.github.io/data/khrSavings1.json") ?? nil
    var requestURLFixedDeposited:URL? = URL(string:"https://willywu0201.github.io/data/khrFixed1.json") ?? nil
    var requestURLDigital:URL? = URL(string:"https://willywu0201.github.io/data/khrDigital1.json") ?? nil
    
    //pull refresh
    var requestURLRefreshSaving: URL? = URL(string: "https://willywu0201.github.io/data/khrSavings2.json") ?? nil
    var requestURLRefreshFixedDeposited: URL? = URL(string: "https://willywu0201.github.io/data/khrFixed2.json") ?? nil
    var requestURLRefreshDigital: URL? = URL(string: "https://willywu0201.github.io/data/khrDigital2.json") ?? nil
    
    func getData(kind:Int, url:URL){
        ApiClient.getDataFromServer(url: url){ (success, data) in
            if success{
                do{
                    let object = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    
                    //因不知道msgCode對應代號，先以文字判斷訊息狀態
                    let msgContent = object?["msgCode"] as! String
                    if(msgContent == "0000"){
                        let result = object?["result"] as? [String:Any] ?? [:]
                        //saving
                        if(kind == 1){
                            //saving
                            let List = result["savingsList"] as? [[String:Any]] ?? []
                            self.setResponseToData(kind:kind, jsonArray: List)
                        } else if (kind == 2){
                            //fixed
                            let List = result["fixedDepositList"] as? [[String:Any]] ?? []
                            self.setResponseToData(kind:kind, jsonArray: List)
                        } else if(kind == 3){
                            //digital
                            let List = result["digitalList"] as? [[String:Any]] ?? []
                            self.setResponseToData(kind:kind, jsonArray: List)
                        }
                        
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
    func getData(mode:Int){
        showLoading?()
        var urlSaving:URL? = nil
        var urlFixed:URL? = nil
        var urlDigital:URL? = nil
        if(mode == 1){
            urlSaving = requestURLSaving!
            urlFixed = requestURLFixedDeposited!
            urlDigital = requestURLDigital!
        } else if(mode == 2){
            urlSaving = requestURLRefreshSaving!
            urlFixed = requestURLRefreshFixedDeposited!
            urlDigital = requestURLRefreshDigital!
        }
        getData(kind: 1, url: urlSaving!)
        getData(kind: 2, url: urlFixed!)
        getData(kind: 3, url: urlDigital!)
    }
    
    func setResponseToData(kind:Int, jsonArray:[[String:Any]]){
        for json in jsonArray{
            let account = json["account"] as? String ?? ""
            let curr = json["curr"] as? String ?? ""
            let balance = json["balance"] as? Float ?? 0.0
            //檢查資料合格性
            //過濾USD
            if(curr == "USD"){
                continue
            }
            
            //寫入資料
            let item = DataAmount(account: account, curr: curr, blance: balance)
            if(kind == 1){
                self.datasSaving.append(item)
            }else if(kind == 2){
                self.datasFixedDeposited.append(item)
            }else if(kind == 3){
                self.datasDigital.append(item)
            }
        }
        hideLoading?()
    }
}
