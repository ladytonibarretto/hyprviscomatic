//
//  ProductViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 11/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var ProductDetailsMenuOptions: UITableView!
    private var _order: Order!
    
    var productList = [Product]()
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    var productName = String()
    var productID = String()
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    var order: Order {
        get {
            return _order
        } set {
            _order = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = productName
        ProductDetailsMenuOptions.tableFooterView = UIView()
        ProductDetailsMenuOptions.delegate = self
        ProductDetailsMenuOptions.dataSource = self
        
        progressBarDisplayer(msg: "Loading...")
        
        getBrands(id: productID, validationCompleted: { (brands) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.strLabel.isEnabled = false
                self.updateArrayMenuOptions(brands: brands)
            }
        })

    }
    
    func updateArrayMenuOptions(brands: [JSON]){
        arrayMenuOptions.removeAll()
        for brand in brands{
            arrayMenuOptions.append(["brand": brand["value"]["brand_name"].stringValue, "price": "1000.00", "quantity": "0"])
        }

        ProductDetailsMenuOptions.reloadData()
    }
    
    func increaseButtonClicked(sender: UIButton){
        let buttonRow = sender.tag
        
        let qty = Int(arrayMenuOptions[buttonRow]["quantity"]!)! + Int(1)
        
        arrayMenuOptions[buttonRow]["quantity"] = String(qty)
        
        ProductDetailsMenuOptions.reloadData()
    }

    func decreaseButtonClicked(sender: UIButton){
        let buttonRow = sender.tag
        
        let qty = Int(arrayMenuOptions[buttonRow]["quantity"]!)! - Int(1)
        
        arrayMenuOptions[buttonRow]["quantity"] = String(qty)
        
        ProductDetailsMenuOptions.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblBrand : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let lblPrice : UILabel = cell.contentView.viewWithTag(202) as! UILabel
        let lblQuantity : UILabel = cell.contentView.viewWithTag(203) as! UILabel
        let decBtn : UIButton? = cell.contentView.viewWithTag(204) as? UIButton
        let incBtn : UIButton? = cell.contentView.viewWithTag(205) as? UIButton

        incBtn?.tag = indexPath.row
        decBtn?.tag = indexPath.row
        
        lblBrand.text = arrayMenuOptions[indexPath.row]["brand"]!
        lblPrice.text = arrayMenuOptions[indexPath.row]["price"]!
        lblQuantity.text = arrayMenuOptions[indexPath.row]["quantity"]!
        
        incBtn?.addTarget(self, action: #selector(increaseButtonClicked), for: .touchUpInside)
        decBtn?.addTarget(self, action: #selector(decreaseButtonClicked), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ ProductDetailsMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
        print("TAPPEEDDD CELL")
    }
    
    func tableView(_ ProductDetailsMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in ProductDetailsMenuOptions: UITableView) -> Int {
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
