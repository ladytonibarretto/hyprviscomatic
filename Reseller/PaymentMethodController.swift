//
//  ProofOfPaymentController.swift
//  Hyprviscomatic
//
//  Created by Lady Barretto on 03/12/2017.
//  Copyright © 2017 Lady Toni Barretto. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaymentMethodController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /**
     *  Array to display menu options
     */
    var arrayMenuOptions = ["Cash On Delivery", "Bank Deposit"]
    let imagePicker = UIImagePickerController()
    var newImage = UIImage()
    var id = String()

    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    @IBOutlet weak var PaymentOptions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PaymentOptions.tableFooterView = UIView()
        PaymentOptions.delegate = self
        PaymentOptions.dataSource = self
    }
    
    func updateArrayMenuOptions(notifications: [JSON]){
        
        PaymentOptions.reloadData()
    }
    
    func tableView(_ PaymentOptions: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PaymentOptions.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblOption : UILabel = cell.contentView.viewWithTag(200) as! UILabel
        
        lblOption.text = arrayMenuOptions[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ PaymentOptions: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        
        if indexPath.row == 1 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else if indexPath.row == 0 {
            progressBarDisplayer(msg: "Loading...")
            self.view.isUserInteractionEnabled = false
            putPurchaseDetails(id: self.id, completionHandler: { (dat, stat) -> Void in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.messageFrame.isUserInteractionEnabled = true
                    self.messageFrame.window?.isUserInteractionEnabled = true
                    self.messageFrame.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    
                    if stat == 201 || stat == 200 {
                        self.showModal(title: "Success!", msg: "Thank you for your order/s. Please wait for confirmation.")

                    } else {
                        self.showModal(title: "Error!", msg: "Unable to process your request. Please try again later.")
                    }
                }
            })

        }
    }
    
    func tableView(_ NotifMenuOptions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in NotifMenuOptions: UITableView) -> Int {
        return 1;
    }
    
    // open gallery
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil);

        newImage = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        
        performSegue(withIdentifier: "pushToBankDepositUpload", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? UploadImageController {
                destination.depImage = (newImage)
                destination.id = self.id
        }
    }


    func showModal(title: String, msg: String){
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
