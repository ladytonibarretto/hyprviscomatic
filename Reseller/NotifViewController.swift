//
//  NotifViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotifViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     *  Array to display menu options
     */
    
    
    @IBOutlet weak var NotifMenuOptions: UITableView!
    
    /**
     *  Array containing menu options
     */
    var notificationsList = [NotificationPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotifMenuOptions.tableFooterView = UIView()
        NotifMenuOptions.delegate = self
        NotifMenuOptions.dataSource = self

        getNotifications(token: ad.token!, validationCompleted: { (notifications) -> Void in
            DispatchQueue.main.async {
                self.updateArrayMenuOptions(notifications: notifications)
            }
        })
    }
    
    func updateArrayMenuOptions(notifications: [JSON]){
        notificationsList = [NotificationPost]()
        
        notificationsList = [NotificationPost]()
        for notification in notifications{
            
            notificationsList.append(NotificationPost(notifTitle:notification["title"].stringValue, notifBody:notification["content"].stringValue, status:notification["status"].stringValue))
        }

        NotifMenuOptions.reloadData()
    }
    
    func tableView(_ NotifMenuOptions: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = NotifMenuOptions.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as? NotifCell {
            
            let notification = notificationsList[indexPath.row]
            
            cell.updateUI(notification: notification) // use to customize each cell
            
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ NotifMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
        let notif = notificationsList[indexPath.row]
        performSegue(withIdentifier: "NotifDetailsViewController", sender: notif)
    }
    
    func tableView(_ NotifMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsList.count
    }
    
    func numberOfSections(in NotifMenuOptions: UITableView) -> Int {
        return 1;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? NotifDetailsViewController {
            
            if let notif = sender as? NotificationPost {
                destination.notif = notif
            }
            
        }
    
    }


}
