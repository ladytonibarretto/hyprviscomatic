//
//  OrderHistoryViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var productNameTable: UITableView!
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()

    /**
     *  Data to be passed to next VC
     */
    var productName = String()
    var productID = String()
    
    /**
     *  For spinner
     */
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
        
        productNameTable.tableFooterView = UIView()
        productNameTable.delegate = self
        productNameTable.dataSource = self
        
        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false
        
        getBrands(token: "", id: productID, validationCompleted: { (products) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.strLabel.isEnabled = false
                self.updateArrayMenuOptions(products: products)
                self.view.isUserInteractionEnabled = true
            }
            
        })
    }
    
    func updateArrayMenuOptions(products: [JSON]){
        arrayMenuOptions.removeAll()
        for product in products{
            arrayMenuOptions.append(["product": product["value"]["product_name"].stringValue])
            arrayMenuOptions.append(["product": "sdsfsdfsdfsdfdsfdsfdsfdsfdsfdsfsdsdafdsgfdhfdgsdfdsgfdhgfhghfghfds"])
        }
        
        productNameTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "productNameCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblBrand : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        
        lblBrand.text = arrayMenuOptions[indexPath.row]["product"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
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
