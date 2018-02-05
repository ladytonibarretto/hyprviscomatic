//
//  NotifDetailsViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 02/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

class NotifDetailsViewController: UIViewController {

    @IBOutlet weak var notifBody: UILabel!
    private var _notif: NotificationPost!
    
    var notif: NotificationPost {
        get {
            return _notif
        } set {
            _notif = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notifBody.text = notif.notifBody
        notifBody.numberOfLines = 0
        notifBody.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
