//
//  BranchesViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit

class BranchesViewController: UIViewController, UITableViewDataSource {
    
    /**
     *  Array to display menu options
     */
    

    @IBOutlet weak var branchMenuOptions: UITableView!

    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    private var _branch: Branch!
    
    var branch: Branch {
        get {
            return _branch
        } set {
            _branch = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        branchMenuOptions.tableFooterView = UIView()
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
    
    @IBAction func addNewBranch(_ sender: AnyObject) {
        performSegue(withIdentifier: "pushToAddNewBranch", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AddBranchViewController {
            destination.isNewAccount = false
        }
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.removeAll()
        
        arrayMenuOptions.append(["BranchName":"Meycauayan Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        arrayMenuOptions.append(["BranchName":"Makati Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        arrayMenuOptions.append(["BranchName":"Taguig Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        arrayMenuOptions.append(["BranchName":"Malolos Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        arrayMenuOptions.append(["BranchName":"Cavite Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        arrayMenuOptions.append(["BranchName":"Batangas Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        arrayMenuOptions.append(["BranchName":"Quezon Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        arrayMenuOptions.append(["BranchName":"Cubao Branch", "BranchAddress":"071 Bagbaguin, Meycauayan, Bulacan","BranchContactNum":"+639178151198"])
        
        branchMenuOptions.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "branchMenuCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblBranchName : UILabel = cell.contentView.viewWithTag(201) as! UILabel
        let lblBranchAddress : UILabel = cell.contentView.viewWithTag(202) as! UILabel
        let lblBranchContactNum : UILabel = cell.contentView.viewWithTag(203) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(200) as! UIImageView
        
        imgIcon.image = UIImage(named: "StoreIcon")
        lblBranchName.text = arrayMenuOptions[indexPath.row]["BranchName"]!
        lblBranchAddress.text = arrayMenuOptions[indexPath.row]["BranchAddress"]!
        lblBranchContactNum.text = arrayMenuOptions[indexPath.row]["BranchContactNum"]!
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("*****CELL TAPPEDDDD!")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
