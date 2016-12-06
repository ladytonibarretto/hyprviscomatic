//
//  OrderDetailsViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var OrderDetailsMenuOptions: UITableView!
        
    private var _order: Order!
    
    var productList = [Product]()
    var arrayMenuOptions = [Dictionary<String,String>]()
    
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
        OrderDetailsMenuOptions.tableFooterView = UIView()
        OrderDetailsMenuOptions.delegate = self
        OrderDetailsMenuOptions.dataSource = self
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.removeAll()

        let items = order.items
        
        for item in items{
            arrayMenuOptions.append(["product": item["product"].stringValue, "brand": item["brand"].stringValue, "price": item["price"].stringValue, "quantity": item["quantity"].stringValue])
        }
        OrderDetailsMenuOptions.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblName : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let lblBrand : UILabel = cell.contentView.viewWithTag(202) as! UILabel
        let lblPrice : UILabel = cell.contentView.viewWithTag(203) as! UILabel
        let lblQuantity : UILabel = cell.contentView.viewWithTag(204) as! UILabel
                
        lblName.text = arrayMenuOptions[indexPath.row]["product"]
        lblBrand.text = arrayMenuOptions[indexPath.row]["brand"]
        lblPrice.text = arrayMenuOptions[indexPath.row]["price"]
        lblQuantity.text = arrayMenuOptions[indexPath.row]["quantity"]
        
        return cell
    }
    
    func tableView(_ OrderDetailsMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
    }
    
    func tableView(_ OrderDetailsMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in OrderDetailsMenuOptions: UITableView) -> Int {
        return 1;
    }
}
