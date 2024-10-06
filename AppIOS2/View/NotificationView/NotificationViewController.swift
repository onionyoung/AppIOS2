//
//  NotificationViewController.swift
//  AppIOS2
//
//  Created by ios on 2024/10/6.
//


import UIKit

class NotificationViewController:UIViewController{
    var datas:[DataNotification] = [DataNotification]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()

        initView()
    }

    func initView(){
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "notificationTableViewCell")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension NotificationViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationTableViewCell", for: indexPath) as? NotificationTableViewCell else {
            fatalError("Cell not exists in storyBoard")
        }
        let item = datas[indexPath.row]
        cell.titleLabel.text = item.title
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        cell.timeLabel.text = formatter.string(from:item.updateDateTime)
        cell.descriptionLabel.text = item.message
        if(item.status){
            cell.notReadView.isHidden = true
        }else{
            cell.notReadView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
}
