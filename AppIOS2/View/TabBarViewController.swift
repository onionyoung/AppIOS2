//
//  TabbarViewController.swift
//  AppIOS2
//
//  Created by ios on 2024/10/5.
//

import UIKit

class TabBarViewController:UIViewController{
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var homeImageVIew: UIImageView!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var serviceImageView: UIImageView!
    
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var servieceLabel: UILabel!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initView()
    }
    func initView(){
        customizeTabBar()
        goToPage(withIdentifier: "HomeViewController")
    }
    func customizeTabBar(){
        tabBarView.layer.shadowOpacity = 0.5
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: 5)
        tabBarView.layer.cornerRadius = tabBarView.frame.height / 2
    }
    @IBAction func tapToChangeViews(_ sender: UIButton) {
        let tag = sender.tag
        switch tag{
        case 1:
            goToPage(withIdentifier: "HomeViewController")
            changeTabBarItemColor(imageview: homeImageVIew, label: homeLabel)
        case 2:
            goToPage(withIdentifier: "AccountViewController")
            changeTabBarItemColor(imageview: accountImageView, label: accountLabel)
        case 3:
            goToPage(withIdentifier: "LocationViewController")
            changeTabBarItemColor(imageview: locationImageView, label: locationLabel)
        case 4:
            goToPage(withIdentifier:"ServiceViewController")
            changeTabBarItemColor(imageview: serviceImageView, label: servieceLabel)
        default: break
        }
    }
    func changeTabBarItemColor(imageview:UIImageView, label:UILabel){
        homeImageVIew.image = homeImageVIew.image?.withRenderingMode(.alwaysTemplate)
        homeImageVIew.tintColor = UIColor(named: "gray7")
        homeLabel.textColor = UIColor(named: "gray7")
        
        accountImageView.image = accountImageView.image?.withRenderingMode(.alwaysTemplate)
        accountImageView.tintColor = UIColor(named: "gray7")
        accountLabel.textColor = UIColor(named: "gray7")
        
        locationImageView.image = locationImageView.image?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor(named: "gray7")
        locationLabel.textColor = UIColor(named: "gray7")
        
        serviceImageView.image = serviceImageView.image?.withRenderingMode(.alwaysTemplate)
        serviceImageView.tintColor = UIColor(named: "gray7")
        servieceLabel.textColor = UIColor(named: "gray7")
        
        imageview.image = imageview.image?.withRenderingMode(.alwaysTemplate)
        imageview.tintColor = UIColor(named: "Orange01")
        label.textColor = UIColor(named: "Orange01")
    }
    func goToPage(withIdentifier identifier:String){
        removeCurrentChildViewController()
        guard let view = self.storyboard?.instantiateViewController(identifier: identifier) as? UIViewController else {return}
        self.addChild(view)
        view.view.frame = contentView.bounds
        contentView.addSubview(view.view)
        view.didMove(toParent: self)
    }
    func removeCurrentChildViewController(){
        for child in children{
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
