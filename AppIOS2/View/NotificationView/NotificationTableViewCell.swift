//
//  NotificationTableViewCell.swift
//  AppIOS2
//
//  Created by ios on 2024/10/6.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notReadView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
