//
//  BranchesViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

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

    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
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
        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false

        let token = "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im1hY3ltaXJhbmRhQGdtYWlsLmNvbSIsIm9yaWdfaWF0IjoxNDgwNDI3ODQ1LCJ1c2VyX2lkIjoxMCwiZW1haWwiOiIiLCJleHAiOjE0ODMwMTk4NDV9.WExIyZLN4s0--03jtoJc37a5-WcvZmF7iodKcGe5WuA"
        
        getBranches(token: token, validationCompleted: { (branches) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.strLabel.isEnabled = false
                self.updateArrayMenuOptions(branches: branches)
                self.view.isUserInteractionEnabled = true
            }
        })

    }
    
    @IBAction func addNewBranch(_ sender: AnyObject) {
        performSegue(withIdentifier: "pushToAddNewBranch", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AddBranchViewController {
            destination.isNewAccount = false
        }
    }
    
    func updateArrayMenuOptions(branches: [JSON]){
        arrayMenuOptions.removeAll()
        for branch in branches{
            arrayMenuOptions.append(["BranchName": branch["name"].stringValue, "BranchAddress": branch["address"].stringValue,"BranchContactNum": branch["phone"].stringValue])
        }
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
