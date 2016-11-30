//
//  OrderHistoryViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     *  Array to display menu options
     */
    
    @IBOutlet weak var OrderMenuOptions: UITableView!

    /**
     *  Array containing menu options
     */
    var orderList = [Order]()
    var arrayMenuOptions = [Dictionary<String,String>]()
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
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        orderList = [Order]()
        arrayMenuOptions.removeAll()
        var items = [Item]()
        let product1 = Product(name: "E-Cigarette", brand: "Marlboro", price: 150.00)
        let product2 = Product(name: "Refillll", brand: "Fortune", price: 2250.00)
        let product3 = Product(name: "E-Cigarette Din", brand: "Chester", price: 9350.00)
        let product4 = Product(name: "Product Test", brand: "Pall", price: 5230.00)
        let item1 = Item(product: product1, quantity: 12)
        let item2 = Item(product: product2, quantity: 4)
        let item3 = Item(product: product3, quantity: 7)
        let item4 = Item(product: product4, quantity: 8)
        items.append(item1)
        items.append(item2)
        items.append(item3)
        items.append(item4)
        
        let test1 = Order(id: 1232345, discount: 100.00, totalPrice: 999.50, status: "Approved", items: items )
        orderList.append(test1)
        orderList.append(test1)
        orderList.append(test1)
        orderList.append(test1)
        orderList.append(test1)
        orderList.append(test1)
        orderList.append(test1)
        orderList.append(test1)
        
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
        arrayMenuOptions.append(["id": String(test1.id),"amount": String(test1.totalPrice), "date":"10-10-2014","time":"10:56", "status":"Approved"])
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
        let lblDate : UILabel = cell.contentView.viewWithTag(203) as! UILabel
        let lblTime : UILabel = cell.contentView.viewWithTag(204) as! UILabel
        let lblStatus : UILabel = cell.contentView.viewWithTag(205) as! UILabel

        lblID.text = arrayMenuOptions[indexPath.row]["id"]!
        lblAmount.text = arrayMenuOptions[indexPath.row]["amount"]!
        lblDate.text = arrayMenuOptions[indexPath.row]["date"]!
        lblTime.text = arrayMenuOptions[indexPath.row]["time"]!
        lblStatus.text = arrayMenuOptions[indexPath.row]["status"]!
        
        return cell
    }
    
    func tableView(_ OrderMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
        let order = orderList[indexPath.row]
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
    
    
}
