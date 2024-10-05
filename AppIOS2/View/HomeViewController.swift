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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
   
        initView()
    }

    func initView(){
        setScrollViewPullRefreshSetting()
        
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
    
    //scrollview下拉更新設定
    func setScrollViewPullRefreshSetting(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新", attributes:[NSAttributedString.Key.foregroundColor: UIColor.blue])
        refreshControl.tintColor = .blue
    }
    @objc func refreshData(){
        print("112233")
        DispatchQueue.main.async{
            sleep(3)
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
}

