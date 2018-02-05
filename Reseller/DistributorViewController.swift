//
//  DistributorViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class DistributorViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     *  Array to display menu options
     */
    
    @IBOutlet weak var distMenuOptions: UITableView!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    var productName = String()
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var productID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.distMenuOptions.tableFooterView = UIView()
        self.distMenuOptions.delegate = self
        self.distMenuOptions.dataSource = self

        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false
        
        getProducts(validationCompleted: { (products) -> Void in
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
        if ad.token != nil && ad.token != "" {
            addSlideMenuButton()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func updateArrayMenuOptions(products: [JSON]){
        arrayMenuOptions.removeAll()
        for product in products{
            let image = product["image"].stringValue
            arrayMenuOptions.append(["icon":image, "id": product["id"].stringValue, "title": product["name"].stringValue])
        }
        distMenuOptions.reloadData()
    }
    
    func tableView(_ distMenuOptions: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = distMenuOptions.dequeueReusableCell(withIdentifier: "productMenuCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
//        let lblTitle : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(200) as! UIImageView
        
        let base64String = arrayMenuOptions[indexPath.row]["icon"]!
        let tokenizedBase64String = base64String.components(separatedBy: ",")[1]
        
        let dataDecoded  = NSData(base64Encoded: tokenizedBase64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!

        imgIcon.image = UIImage(data: dataDecoded as Data)
        
        return cell
    }
    
    internal func tableView(_ distMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
        productName = arrayMenuOptions[indexPath.row]["title"]!
        productID = arrayMenuOptions[indexPath.row]["id"]!
        
        if ad.token != nil && ad.token != "" {
            print("******NULL")
            performSegue(withIdentifier: "pushToProducts", sender: nil)
        } else {
            print("******NOT NULL")
            performSegue(withIdentifier: "pushToProductNamesOnly", sender: nil)
        }
    }
    
    func tableView(_ distMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "pushToProducts", let destination = segue.destination as? ProductsViewController{
            destination.productName = productName
            destination.productID = productID
        } else {
            let destination = segue.destination as? ProductNameViewController
            destination?.productName = productName
            destination?.productID = productID
        }
    }

}
