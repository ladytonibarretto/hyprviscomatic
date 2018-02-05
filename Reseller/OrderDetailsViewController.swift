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
        
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var shippingFeeLbl: UILabel!
    @IBOutlet weak var submitProofBtn: UIButton!
    @IBOutlet weak var netTotalView: UIView!
    
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
        
        checkStatus()
        updateArrayMenuOptions()
        updateTotalAmount()        
    }
    
    // Check Order Status
    func checkStatus(){
        
        // if payment method is not set show button for proof of payment
        if order.payment_method != "" {
            self.submitProofBtn.isHidden = true
            
            let constraintNetView = NSLayoutConstraint(item: netTotalView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            
            self.view.addConstraint(constraintNetView)
        }
    }
    
    func updateTotalAmount(){
        var amount: Double
        
        amount = 0
        for item in arrayMenuOptions{
            let price = Double(item["price"]!)
            let qty = Double(item["quantity"]!)
            amount = amount + (price! * qty!)
        }
        
        let discount = amount * (Double(order.discount)! / 100 )
        let shippingFee = Double(order.shipping_fee)!
        let net = (amount - discount) + shippingFee
        subTotalLbl.text = "\(amount) Php"
        discountLbl.text = "\(discount) Php"
        shippingFeeLbl.text = "\(shippingFee) Php"
        totalAmountLbl.text = "\(net) Php"
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.removeAll()

        let items = order.items
        
        for item in items{
            arrayMenuOptions.append(["product": item["product"].stringValue, "brand": item["brand"].stringValue, "price": item["price"].stringValue, "discount": item["discount"].stringValue, "quantity": item["quantity"].stringValue])
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? PaymentMethodController {
            destination.id = order.id
        }
    }

}
