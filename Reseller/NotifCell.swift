//
//  NotifCell.swift
//  Reseller
//
//  Created by Lady Barretto on 04/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

class NotifCell: UITableViewCell {
    
    
    @IBOutlet weak var notifIcon: UIImageView!
    @IBOutlet weak var notifTitle: UILabel!
    @IBOutlet weak var notifBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(notification: NotificationPost) {
        notifTitle.text = notification.notifTitle
        notifBody.text = notification.notifBody
        notifIcon.image = UIImage(named: "NotificationsIcon")
        
//        if notification.status != "Seen"{
//            notifTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
//        } else {
//            notifTitle.textColor = UIColor.lightGray
//            notifBody.textColor = UIColor.lightGray
//        }
        
    }
    
}
