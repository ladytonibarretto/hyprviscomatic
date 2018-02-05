//
//  ProductsViewController.swift
//  Hyprviscomatic
//
//  Created by Lady Barretto on 09/01/2017.
//  Copyright © 2017 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductsViewController: UITableViewController {
    
    var storedOffsets = [Int: CGFloat]()
    
    var productName = String()
    var productID = String()
    
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProductsViewController.textFieldDidChange), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: nil)
    }
    
    func textFieldDidChange(sender : NSNotification) {
        
        let textFieldChanged = sender.object as? UITextField
        arrayMenuOptions[(textFieldChanged?.tag)!]["quantity"] = textFieldChanged?.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = productName
        
        progressBarDisplayer(msg: "Loading...")
        
        var token: String
        
        if ad.token != nil {
            token = ad.token!
        } else {
            token = ""
        }
        
        // TODO: switch naming of brand to product and vice versa
        getBrands(token: token, id: productID, validationCompleted: { (brands) -> Void in
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let lblBrand : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let lblPrice : UILabel = cell.contentView.viewWithTag(202) as! UILabel
        let decBtn : UIButton? = cell.contentView.viewWithTag(204) as? UIButton
        let incBtn : UIButton? = cell.contentView.viewWithTag(205) as? UIButton
        let addToCartBtn : UIButton? = cell.contentView.viewWithTag(206) as? UIButton
        let qtyText : UITextField? = cell.contentView.viewWithTag(207) as? UITextField
        
        incBtn?.tag = indexPath.row
        decBtn?.tag = indexPath.row
        qtyText?.tag = indexPath.row
        addToCartBtn?.tag = indexPath.row
        
        lblBrand.text = arrayMenuOptions[indexPath.row]["brand"]!
        lblPrice.text = "\(arrayMenuOptions[indexPath.row]["price"]!) Php"
        qtyText?.text = arrayMenuOptions[indexPath.row]["quantity"]!
        
        addToCartBtn?.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func updateArrayMenuOptions(brands: [JSON]){
        arrayMenuOptions.removeAll()
        for brand in brands{
            arrayMenuOptions.append(["brand": brand["value"]["product_name"].stringValue, "price": brand["value"]["price"].stringValue, "quantity": "0", "brandID": brand["value"]["product"].stringValue, "attributeID": brand["id"].stringValue])
        }
        
        tableView.reloadData()
    }
    
    func addToCart(sender: UIButton){
        let buttonRow = sender.tag
        let item = NativeItem()
        item.product = self.productName
        item.productID = UInt(self.productID)!
        item.brand = arrayMenuOptions[buttonRow]["brand"]!
        item.brandID = UInt(arrayMenuOptions[buttonRow]["brandID"]!)!
        item.price = Double(arrayMenuOptions[buttonRow]["price"]!)!
        item.attribute_id = UInt(arrayMenuOptions[buttonRow]["attributeID"]!)!
        item.quantity = UInt(arrayMenuOptions[buttonRow]["quantity"]!)!
        
        if item.quantity > 0 {
            ad.cartItems.append(item)
            showModal(title: "Success!", msg: "Added to Shopping Cart")
        } else {
            showModal(title: "Oops!", msg: "Please add quantity.")
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
    
    func showModal(title: String, msg: String){
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

