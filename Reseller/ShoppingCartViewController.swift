//
//  ShoppingCartViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource {
    
    /**
     *  Array to display menu options
     */
    
    @IBOutlet weak var cartMenuOptions: UITableView!
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.removeAll()
        arrayMenuOptions.append(["icon":"ShoppingCartIcon","ProductName":"E-Cigarette", "ProductBrand":"Marlboro","Price":"100.00", "Quantity":"3", "TotalAmount":"300.00"])
        arrayMenuOptions.append(["icon":"ShoppingCartIcon","ProductName":"E-Cigarette", "ProductBrand":"Marlboro","Price":"100.00", "Quantity":"3", "TotalAmount":"300.00"])
        arrayMenuOptions.append(["icon":"ShoppingCartIcon","ProductName":"E-Cigarette", "ProductBrand":"Marlboro","Price":"100.00", "Quantity":"3", "TotalAmount":"300.00"])
        arrayMenuOptions.append(["icon":"ShoppingCartIcon","ProductName":"E-Cigarette", "ProductBrand":"Marlboro","Price":"100.00", "Quantity":"3", "TotalAmount":"300.00"])
        arrayMenuOptions.append(["icon":"ShoppingCartIcon","ProductName":"E-Cigarette", "ProductBrand":"Marlboro","Price":"100.00", "Quantity":"3", "TotalAmount":"300.00"])
        arrayMenuOptions.append(["icon":"ShoppingCartIcon","ProductName":"E-Cigarette", "ProductBrand":"Marlboro","Price":"100.00", "Quantity":"3", "TotalAmount":"300.00"])
        arrayMenuOptions.append(["icon":"ShoppingCartIcon","ProductName":"E-Cigarette", "ProductBrand":"Marlboro","Price":"100.00", "Quantity":"3", "TotalAmount":"300.00"])
        
        cartMenuOptions.reloadData()
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
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblProductName.text = arrayMenuOptions[indexPath.row]["ProductName"]!
        lblProductBrand.text = arrayMenuOptions[indexPath.row]["ProductBrand"]!
        lblPrice.text = arrayMenuOptions[indexPath.row]["Price"]!
        lblQuantity.text = arrayMenuOptions[indexPath.row]["Quantity"]!
        lblTotalAmount.text = arrayMenuOptions[indexPath.row]["TotalAmount"]!
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
