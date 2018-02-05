//
//  OrderHistoryViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     *  Array to display menu options
     */
    
    @IBOutlet weak var OrderMenuOptions: UITableView!

    /**
     *  Array containing menu options
     */
    var orderList = [Order]()
    var arrayMenuOptions = [Order]()
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        OrderMenuOptions.tableFooterView = UIView()
        OrderMenuOptions.delegate = self
        OrderMenuOptions.dataSource = self
        
        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false
        
        getPurchases(token: ad.token!, validationCompleted: { (purchases) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.strLabel.isEnabled = false
                self.updateArrayMenuOptions(purchases: purchases)
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    func updateArrayMenuOptions(purchases: [JSON]){
        orderList = [Order]()
        arrayMenuOptions.removeAll()
        
        for purchase in purchases{
            let order = Order(id: purchase["id"].stringValue,
                          totalPrice: purchase["total"].stringValue,
                          discount: purchase["discount"].stringValue,
                          shipping_fee: purchase["shipping_fee"].stringValue,
                          status: purchase["status"].stringValue.capitalized,
                          dateAdded: purchase["date_added"].double!,
                          receipt: purchase["receipt"].stringValue,
                          payment_method: purchase["payment_method"].stringValue,
                          items: purchase["items"].array!)
            
            arrayMenuOptions.append(order)
        }
        OrderMenuOptions.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblID : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let lblAmount : UILabel = cell.contentView.viewWithTag(202) as! UILabel
        let lblDiscount : UILabel = cell.contentView.viewWithTag(206) as! UILabel
        let lblDate : UILabel = cell.contentView.viewWithTag(203) as! UILabel
        let lblStatus : UILabel = cell.contentView.viewWithTag(205) as! UILabel

        let amount = Double(arrayMenuOptions[indexPath.row].totalPrice)
        let discount = amount! * (Double(arrayMenuOptions[indexPath.row].discount)! / 100)
        
        lblID.text = String(arrayMenuOptions[indexPath.row].id)
        lblAmount.text = "\(arrayMenuOptions[indexPath.row].totalPrice) Php"
        lblDiscount.text = "\(discount) Php"
        let dateDoub = arrayMenuOptions[indexPath.row].dateAdded
        let dateStr = String(describing: NSDate(timeIntervalSince1970: dateDoub))
        lblDate.text = dateStr
        lblStatus.text = arrayMenuOptions[indexPath.row].status
        
        return cell
    }
    
    func tableView(_ OrderMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
        let order = arrayMenuOptions[indexPath.row]
        performSegue(withIdentifier: "pushToOrderDetails", sender: order)
    }
    
    func tableView(_ OrderMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in OrderMenuOptions: UITableView) -> Int {
        return 1;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? OrderDetailsViewController {
            
            if let order = sender as? Order {
                destination.order = order
            }
            
        }
    }
    
    func progressBarDisplayer(msg:String) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 1)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
}
