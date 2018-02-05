//
//  ShoppingCartViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShoppingCartViewController: UIViewController, UITableViewDataSource {
    
    /**
     *  Array to display menu options
     */
    
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var checkoutBarBtn: UIBarButtonItem!
    @IBOutlet weak var cartMenuOptions: UITableView!
    
    var cartArrayMenuOptions = [Dictionary<String,String>]()
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var discount = 0.0

    /**
     *  Array containing menu options
     */    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartMenuOptions.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if ad.cartItems.count == 0 {
            checkoutBarBtn.isEnabled = false
        }
        getDiscount(validationCompleted: { (discount, stat) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                
                if stat == 201 || stat == 200{
                    self.discount = discount
                    self.updateArrayMenuOptions()
                    self.updateTotalAmount()

                } else {
                    self.showModal(title: "Error!", msg: "Unable to process your request. Please try again later.")
                }
                
            }
        })

    }
    
    @IBAction func checkout(_ sender: Any) {
        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false
        postPurchase(discount: self.discount, orders: ad.cartItems, validationCompleted: { (dat, stat) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                
                if stat == 201 {
                    self.showModal(title: "Success!", msg: "Thank you for your order/s. Please wait for confirmation.")
                } else {
                    self.showModal(title: "Error!", msg: "Unable to process your request. Please try again later.")
                }
            }
        })
    }
    
    func showModal(title: String, msg: String){
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateArrayMenuOptions(){
        cartArrayMenuOptions.removeAll()
        
        for item in ad.cartItems {
            let total = item.price * Double(item.quantity)
            cartArrayMenuOptions.append(["icon":"ic_products","ProductName":item.product, "ProductBrand":item.brand,"Price":String(item.price), "Quantity":String(item.quantity), "TotalAmount":String(total), "ProductID":String(item.productID), "BrandID": String(item.brandID), "AttributeID": String(item.attribute_id)])
        }
        
        cartMenuOptions.reloadData()
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cartMenuCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblProductName : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let lblProductBrand : UILabel = cell.contentView.viewWithTag(202) as! UILabel
        let lblPrice : UILabel = cell.contentView.viewWithTag(203) as! UILabel
        let lblQuantity : UILabel = cell.contentView.viewWithTag(204) as! UILabel
        let lblTotalAmount : UILabel = cell.contentView.viewWithTag(205) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(200) as! UIImageView
        let deleteBtn : UIButton? = cell.contentView.viewWithTag(206) as? UIButton

        deleteBtn?.tag = indexPath.row

        imgIcon.image = UIImage(named: cartArrayMenuOptions[indexPath.row]["icon"]!)
        lblProductName.text = cartArrayMenuOptions[indexPath.row]["ProductName"]!
        lblProductBrand.text = cartArrayMenuOptions[indexPath.row]["ProductBrand"]!
        lblPrice.text = "\(cartArrayMenuOptions[indexPath.row]["Price"]!) Php"
        lblQuantity.text = cartArrayMenuOptions[indexPath.row]["Quantity"]!
        lblTotalAmount.text = "\(cartArrayMenuOptions[indexPath.row]["TotalAmount"]!) Php"
        
        deleteBtn?.addTarget(self, action: #selector(deleteItemFromCart), for: .touchUpInside)

        
        return cell
    }
    
    
    func deleteItemFromCart(sender: UIButton){
        let buttonRow = sender.tag
        
        cartArrayMenuOptions.remove(at: buttonRow)
        updateTotalAmount()
        cartMenuOptions.reloadData()
        ad.cartItems.remove(at: buttonRow)
        
        if ad.cartItems.count == 0 {
            checkoutBarBtn.isEnabled = false
        }
    }

    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func updateTotalAmount(){
        var amount: Double
        
        amount = 0
        for item in cartArrayMenuOptions{
            let price = Double(item["TotalAmount"]!)
            amount = amount + price!
        }
        
        let discount = amount * (self.discount / 100)
        let net = amount - discount
        
        subTotalLbl.text = "\(amount) Php"
        discountLbl.text = "\(discount) Php"
        totalAmtLbl.text = "\(net) Php"
    }

}
