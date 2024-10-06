//
//  ViewController.swift
//  AppIOS2
//
//  Created by ios on 2024/10/4.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var adView: UIView!
    var dataADBannerViewModel = DataADBannerViewModel()
    var dataFavoriteViewModel = DataFavoriteViewModel()
    var dataNotificationViewModel = DataNotificationViewModel()
    var dataUSDAmountViewModel = DataUSDAmountViewModel()
    var dataKHRAmountViewModel = DataKHRAmountViewModel()
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var nilFavoriteView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var isloading = false
    
    @IBOutlet weak var usdSavingLabel: UILabel!
    @IBOutlet weak var usdfixLabel: UILabel!
    @IBOutlet weak var usdDigitalLabel: UILabel!
    
    @IBOutlet weak var khrSavingLabel: UILabel!
    @IBOutlet weak var khrfixLabel: UILabel!
    @IBOutlet weak var khrDigitalLabel: UILabel!
    var amountShow = true;
    @IBOutlet weak var eyeImageView: UIImageView!
    
    @IBOutlet weak var notificationImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
    }
    
    
    func initView(){
        setScrollViewPullRefreshSetting()
        //收藏功能設定
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        dataFavoriteViewModel.reloadData = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                self.favoriteCollectionView.reloadData()
            }
        }
        //ad設定
        adSetting()
        //amount設定
        amountSetting()
        //通知設定
        notificationSetting()
        
        //取得資料
        getData(firstOpen: true)
    }
    
    func getData(firstOpen:Bool){
        //ad
        if(!firstOpen){
            dataADBannerViewModel.getData()
            dataFavoriteViewModel.getData(mode: 2)
            dataNotificationViewModel.getData(mode: 2)
            dataUSDAmountViewModel.getData(mode: 2)
            dataKHRAmountViewModel.getData(mode: 2)
        }else{
            //empty(mode = 1)
            dataFavoriteViewModel.getData(mode: 1)
            dataNotificationViewModel.getData(mode: 1)
            //First Open(mode = 1)
            dataUSDAmountViewModel.getData(mode: 1)
            dataKHRAmountViewModel.getData(mode: 1)
        }
    }
    
    func amountSetting(){
        //usd amount
        dataUSDAmountViewModel.reloadDataSaving = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                self.usdSavingData()
            }
        }
        dataUSDAmountViewModel.reloadDataFix = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                self.usdFixData()
            }
        }
        dataUSDAmountViewModel.reloadDataDigital = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                self.usdDigitalData()
            }
        }
        
        dataKHRAmountViewModel.reloadDataSaving = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                self.khrSavingData()
            }
        }
        dataKHRAmountViewModel.reloadDataFix = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                self.khrFixData()
            }
        }
        dataKHRAmountViewModel.reloadDataDigital = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                self.khrDigitalData()
            }
        }
    }
    //AD設定
    func adSetting(){
        var adCarouseView: ADCarouselView!
        adCarouseView = ADCarouselView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 120))
        self.adView.addSubview(adCarouseView)
        
        dataADBannerViewModel.reloadData = {
            DispatchQueue.main.async{
                self.checkGetDataIsFinish()
                let ads = self.dataADBannerViewModel.datas
                adCarouseView.ads = ads
                adCarouseView.collectionView.reloadData()
            }
        }
    }
    func notificationSetting(){
        dataNotificationViewModel.reloadData = {
            DispatchQueue.main.async {
                self.checkGetDataIsFinish()
                if(self.dataNotificationViewModel.hasNewNotification){
                    self.notificationImageView.image = UIImage(named: "iconBell02Active")
                }else{
                    self.notificationImageView.image = UIImage(named:"iconBell01Nomal")
                }
            }
        }
    }
    //scrollview下拉更新設定
    func setScrollViewPullRefreshSetting(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新", attributes:[NSAttributedString.Key.foregroundColor: UIColor.blue])
        refreshControl.tintColor = .blue
        
    }
    
    //數字格式
    func formatNumber(_ number:Double)->String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        
        return formatter.string(from: NSNumber(value: number))
    }
    @objc func refreshData(){
        isloading = true
        DispatchQueue.main.async{
            self.getData(firstOpen:false)
        }
    }
    func checkGetDataIsFinish(){
        if(self.dataFavoriteViewModel.requestIsFinish &&
           self.dataNotificationViewModel.requestIsFinish &&
           self.dataADBannerViewModel.requestIsFinish &&
           self.dataKHRAmountViewModel.requestIsFinish &&
           self.dataUSDAmountViewModel.requestIsFinish){
            if(isloading){
                isloading = false
                
                self.scrollView.refreshControl?.endRefreshing()
            }
        }
    }
    @IBAction func eyeButton(_ sender: Any) {
        amountShow = !amountShow
        if(amountShow){
            eyeImageView.image = UIImage(named: "iconEye01On")
        }else{
            eyeImageView.image = UIImage(named: "iconEye02Off")
        }
        self.usdSavingData()
        self.usdFixData()
        self.usdDigitalData()
        self.khrSavingData()
        self.khrFixData()
        self.khrDigitalData()
    }
    func usdSavingData(){
        if(!self.amountShow) {
            self.usdSavingLabel.text = "******"
            return
        }
        let data = self.dataUSDAmountViewModel.datasSaving
        if(data.count > 0){
            self.usdSavingLabel.text = self.formatNumber(data[0].blance)
        } else{
            self.usdSavingLabel.text = "0"
        }
    }
    func usdFixData(){
        if(!self.amountShow) {
            self.usdfixLabel.text = "******"
            return
        }
        let data = self.dataUSDAmountViewModel.datasFixedDeposited
        if(data.count > 0){
            self.usdfixLabel.text = self.formatNumber(data[0].blance)
        } else{
            self.usdfixLabel.text = "0"
        }
    }
    func usdDigitalData(){
        if(!self.amountShow) {
            self.usdDigitalLabel.text = "******"
            return
        }
        let data = self.dataUSDAmountViewModel.datasDigital
        if(data.count > 0){
            self.usdDigitalLabel.text = self.formatNumber(data[0].blance)
        } else{
            self.usdDigitalLabel.text = "0"
        }
    }
    func khrSavingData(){
        if(!self.amountShow) {
            self.khrSavingLabel.text = "******"
            return
        }
        let data = self.dataKHRAmountViewModel.datasSaving
        if(data.count > 0){
            self.khrSavingLabel.text = self.formatNumber(data[0].blance)
        } else{
            self.khrSavingLabel.text = "0"
        }
    }
    func khrFixData(){
        if(!self.amountShow) {
            self.khrfixLabel.text = "******"
            return
        }
        let data = self.dataKHRAmountViewModel.datasFixedDeposited
        if(data.count > 0){
            self.khrfixLabel.text = self.formatNumber(data[0].blance)
        } else{
            self.khrfixLabel.text = "0"
        }
    }
    func khrDigitalData(){
        if(!self.amountShow) {
            self.khrDigitalLabel.text = "******"
            return
        }
        let data = self.dataKHRAmountViewModel.datasDigital
        if(data.count > 0){
            self.khrDigitalLabel.text = self.formatNumber(data[0].blance)
        } else{
            self.khrDigitalLabel.text = "0"
        }
    }
    @IBAction func notificationButton(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "notificationViewController") as! NotificationViewController
        viewController.datas = dataNotificationViewModel.datas
        present(viewController, animated:true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.dataFavoriteViewModel.datas.count
        if(count > 0){
            nilFavoriteView.isHidden = true
        }else{
            nilFavoriteView.isHidden = false
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            fatalError("Cell not exists in storyBoard")
        }
        let item = self.dataFavoriteViewModel.datas[indexPath.row]
        
        switch item.transType{
        case "CUBC":
            cell.favoriteImageView.image = UIImage(named:"button00ElementScrollTree")
        case "Mobile":
            cell.favoriteImageView.image = UIImage(named:"button00ElementScrollMobile")
        case "PMF":
            cell.favoriteImageView.image = UIImage(named:"button00ElementScrollBuilding")
        case "CreditCard":
            cell.favoriteImageView.image = UIImage(named:"button00ElementScrollCreditCard")
        default: break
        }
        cell.favoriteLabel.text = item.nickname
        return cell
    }
}

