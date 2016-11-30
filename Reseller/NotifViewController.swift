//
//  NotifViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

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
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        notificationsList = [NotificationPost]()
        let test1 = NotificationPost(notifTitle:"GrabCar Promo!sdfdsfsdfsdfdsfdsfdsfsdfdsf sdfsdfdsfsddsf", notifBody:"20% discount on selected items", status: "No")
        let test2 = NotificationPost(notifTitle:"GrabCar Announcement!", notifBody:"20% discount on selected itemssdf sdf jlsjdfk ljsd aksd ja,n a,smnd ja,nsd j,anmsd jamnsd j,adn jasnd asjdn asjdn asldn asldn asldn aslkd nlasdn asld nasm,d nas,", status: "Seen")
        let test3 = NotificationPost(notifTitle:"Seat Sale!", notifBody:"20% discount on selected items", status: "Seen")
        let test4 = NotificationPost(notifTitle:"Promo tonight!", notifBody:"20% discount on selected items", status: "Seen")
        let test5 = NotificationPost(notifTitle:"Promo tonight!", notifBody:"20% discount on selected items", status: "No")
        let test6 = NotificationPost(notifTitle:"Promo tonight!", notifBody:"20% discount on selected items", status: "No")
        notificationsList.append(test1)
        notificationsList.append(test2)
        notificationsList.append(test3)
        notificationsList.append(test4)
        notificationsList.append(test5)
        notificationsList.append(test6)

        NotifMenuOptions.reloadData()
    }
    
    func tableView(_ NotifMenuOptions: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = NotifMenuOptions.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as? NotifCell {
            
            let notification = notificationsList[indexPath.row]
            
            cell.updateUI(notification: notification)
            
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
