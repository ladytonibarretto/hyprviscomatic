//
//  DistributorViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
//        let isValid = getProducts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        distMenuOptions.tableFooterView = UIView()
        distMenuOptions.delegate = self
        distMenuOptions.dataSource = self
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.removeAll()
        arrayMenuOptions.append(["title":"Marlboro", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Winston", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Philips", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Fortune", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Chesterfields", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Palm Mall", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Marlboro", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Winston", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Philips", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Fortune", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Chesterfields", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Palm Mall", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Marlboro", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Winston", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Philips", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Fortune", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Chesterfields", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Palm Mall", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Marlboro", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Winston", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Philips", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Fortune", "icon":"CameraIcon"])
        arrayMenuOptions.append(["title":"Chesterfields", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Palm Mall", "icon":"HomeIcon"])
        
        distMenuOptions.reloadData()
    }
    
    func tableView(_ distMenuOptions: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = distMenuOptions.dequeueReusableCell(withIdentifier: "productMenuCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(200) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    internal func tableView(_ distMenuOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
        productName = arrayMenuOptions[indexPath.row]["title"]!
        
        performSegue(withIdentifier: "pushToProductBrands", sender: "")

    }
    
    func tableView(_ distMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if let destination = segue.destination as? ProductViewController {
            destination.productName = productName
        }
        
    }

}
