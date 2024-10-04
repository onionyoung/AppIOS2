//
//  ViewController.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//

import UIKit

class ViewController: UIViewController {

    var dataADBannerViewModel = DataADBannerViewModel()
    var dataFavoriteViewModel = DataFavoriteViewModel()
    var dataNotificationViewModel = DataNotificationViewModel()
    var dataUSDAmountViewModel = DataUSDAmountViewModel()
    var dataKHRAmountViewModel = DataKHRAmountViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
    }

    func initView(){
        dataADBannerViewModel.hideLoading = {
            DispatchQueue.main.async{
                
            }
        }
        dataADBannerViewModel.showLoading = {
            DispatchQueue.main.async{
                
            }
        }
        
        dataADBannerViewModel.getData()
        //empty(mode = 1)
        dataFavoriteViewModel.getData(mode: 2)
        dataNotificationViewModel.getData(mode: 2)
        //First Open(mode = 1)
        dataUSDAmountViewModel.getData(mode: 1)
        dataKHRAmountViewModel.getData(mode: 1)
    }

}

