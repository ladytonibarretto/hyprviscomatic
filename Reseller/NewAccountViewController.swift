//
//  NewAccountViewController.swift
//  Reseller
//
//  Created by Lady Toni Barretto on 10/18/16.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

import UIKit

class NewAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newAcctScrollView: UIScrollView!
    @IBOutlet weak var shopName: UITextField?
    @IBOutlet weak var addBranchLabel: UILabel?
    @IBOutlet weak var addBranchBtn: UIButton?
    @IBOutlet weak var branchNameLbl: UILabel?
    @IBOutlet weak var branchAddressLbl: UILabel?
    @IBOutlet weak var branchPhoneLbl: UILabel?
    @IBOutlet weak var branchName: UILabel?
    @IBOutlet weak var address: UILabel?
    @IBOutlet weak var phone: UILabel?
    @IBOutlet weak var storeImgLbl: UILabel?
    @IBOutlet weak var permitImgLbl: UILabel?
    @IBOutlet weak var storeImg1: UIImageView!
    @IBOutlet weak var storeImg2: UIImageView!
    @IBOutlet weak var storeImg3: UIImageView!
    @IBOutlet weak var permitImg1: UIImageView!
    @IBOutlet weak var permitImg2: UIImageView!
    @IBOutlet weak var permitImg3: UIImageView!
    
    @IBOutlet weak var shopNameField: UITextField!
    @IBOutlet weak var shopAddressField: UITextField!
    @IBOutlet weak var contactNumField: UITextField!
    @IBOutlet weak var shippingAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailAddField: UITextField!

    private var _branch: Branch!

    var isNewBranchAdded = false
    
    var storeTmpImg1 : UIImage?
    var storeTmpImg2 : UIImage?
    var storeTmpImg3 : UIImage?
    var permitTmpImg1 : UIImage?
    var permitTmpImg2 : UIImage?
    var permitTmpImg3 : UIImage?

    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    var storeImgList = [UIImageView]()
    var permitImgList = [UIImageView]()
    
    
    var branch: Branch {
        get {
            return _branch
        } set {
            _branch = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeImgList = [storeImg1, storeImg2, storeImg3]
        permitImgList = [permitImg1, permitImg2, permitImg3]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewAccountViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
  
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(false)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        let desiredOffset = CGPoint(x: 0, y: 0)
        self.newAcctScrollView.setContentOffset(desiredOffset, animated: true)

        if isNewBranchAdded{
            print("new branchhhhh")
            branchName?.text = branch.name
            address?.text = branch.address
            phone?.text = branch.phone
            addBranchBtn?.removeFromSuperview()

            storeImg1.image = storeTmpImg1
            storeImg2.image = storeTmpImg2
            storeImg3.image = storeTmpImg3
            permitImg1.image = permitTmpImg1
            permitImg2.image = permitTmpImg2
            permitImg3.image = permitTmpImg3
        } else {
            branchName?.removeFromSuperview()
            branchNameLbl?.removeFromSuperview()
            branchAddressLbl?.removeFromSuperview()
            address?.removeFromSuperview()
            phone?.removeFromSuperview()
            branchPhoneLbl?.removeFromSuperview()
            storeImgLbl?.removeFromSuperview()
            permitImgLbl?.removeFromSuperview()
        }
        
        
        if isNewBranchAdded {
            print("newwww")
        } else {
            print("oldddd")
        }

    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }

    
    @IBAction func saveNewAcct(_ sender: AnyObject) {
        if isNewBranchAdded {
            if shopNameField!.text == "" || shopAddressField!.text == "" || contactNumField!.text == "" || shippingAddressField!.text == "" || passwordField!.text == "" || emailAddField!.text == "" {
                showModal(title: "Error!", msg: "Missing required fields", isComplete: false)
            } else {
                registerAccount()
            }
            
        } else {
            showModal(title: "Error!", msg: "Adding main branch is required", isComplete: false)
        }
    }
    
    func showModal(title: String, msg: String, isComplete: Bool){
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { action -> Void in
                print("Success!")
            if isComplete {
                self.performSegue(withIdentifier: "pushToSignIn", sender: nil)
            }
        })
        
        self.present(alertController, animated: true, completion: nil)

    }

    func convertPhotosToBase64() -> ImageModel {
        
        let branch = ImageModel()
        var stringBaseList = [String]()
        
        for imageView in storeImgList {
            if imageView.image != nil {
                let storeImgData = UIImageJPEGRepresentation((imageView.image)!, 0.5)
                var storeImgString = storeImgData?.base64EncodedString(options:Data.Base64EncodingOptions(rawValue: UInt(0)))
                
                storeImgString = "data:image/jpeg;base64," + storeImgString!
                stringBaseList.append(storeImgString!)
            }
        }
        
        for imageView in permitImgList {
            if imageView.image != nil {
                let permitImgData = UIImageJPEGRepresentation(imageView.image!, 0.5)
                let permitImgString = permitImgData?.base64EncodedString(options: [])
                stringBaseList.append(permitImgString!)
            }
        }

        branch.stringBase = stringBaseList
        
        return branch
        
    }
    
    
    func registerAccount(){
        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false
        
        let newAccount = Registration()
        newAccount.shopName = shopNameField.text!
        newAccount.shopAddress = shopAddressField.text!
        newAccount.contactNum = contactNumField.text!
        newAccount.shippingAddress = shippingAddressField.text!
        newAccount.email = emailAddField.text!
        newAccount.password = passwordField.text!
        
        let branchImage = convertPhotosToBase64()
        
        let newBranch = Branch()
        newBranch.name = (branchName?.text)!
        newBranch.address = (address?.text)!
        newBranch.phone = (phone?.text)!
        newBranch.photos = branchImage
        
        newAccount.branchModels.append(newBranch)
        
        postRegistration(registrationModel: newAccount, validationCompleted: { (dat, stat) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.view.isUserInteractionEnabled = true

                self.strLabel.isEnabled = false
                
                if stat == 200 {
                    self.showModal(title: "Thank you for signing up!", msg: "Your account is pending for approval", isComplete: true)
                } else {
                    self.showModal(title: "Error!", msg: "Cannot process your request...", isComplete: false)
                }
            }
        })

    
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

    override func viewDidAppear(_ animated: Bool){
        

    }
    
    @IBAction func submitNewAccount(_ sender: AnyObject) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
