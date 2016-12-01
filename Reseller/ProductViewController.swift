//
//  ProductViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 11/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var ProductDetailsMenuOptions: UITableView!
    private var _order: Order!
    
    var productList = [Product]()
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    var productName = String()
    
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
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.removeAll()
        
        arrayMenuOptions.append(["brand": "Brand1", "price": "1000.00", "quantity": "10"])
        arrayMenuOptions.append(["brand": "Brand1", "price": "1000.00", "quantity": "10"])
        arrayMenuOptions.append(["brand": "Brand1", "price": "1000.00", "quantity": "10"])
        arrayMenuOptions.append(["brand": "Brand1", "price": "1000.00", "quantity": "10"])
        arrayMenuOptions.append(["brand": "Brand1", "price": "1000.00", "quantity": "10"])
        arrayMenuOptions.append(["brand": "Brand1", "price": "1000.00", "quantity": "10"])
        
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

        lblBrand.text = arrayMenuOptions[indexPath.row]["brand"]!
        lblPrice.text = arrayMenuOptions[indexPath.row]["price"]!
        lblQuantity.text = arrayMenuOptions[indexPath.row]["quantity"]!
        
        return cell
    }
    
    func tableView(_ ProductDetailsMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
    }
    
    func tableView(_ ProductDetailsMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in ProductDetailsMenuOptions: UITableView) -> Int {
        return 1;
    }

}
