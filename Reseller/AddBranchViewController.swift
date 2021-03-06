//
//  AddBranchViewController.swift
//  Reseller
//
//  Created by Lady Toni Barretto on 10/18/16.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

class AddBranchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addBranchScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addStoreImageBtn: UIImageView!
    @IBOutlet weak var addPermitImageBtn: UIImageView!
    
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeImg2: UIImageView!
    @IBOutlet weak var storeImg3: UIImageView!

    @IBOutlet weak var permitImg: UIImageView!
    @IBOutlet weak var permitImg2: UIImageView!
    @IBOutlet weak var permitImg3: UIImageView!
    
    @IBOutlet weak var branchName: UITextField!
    @IBOutlet weak var branchAddress: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var addMapAddressBtn: UIButton!
    @IBOutlet weak var addMapAddressLabel: UILabel!
    var imageHere : UIImageView?
    var newImageView : UIImageView?
    let imagePicker = UIImagePickerController()
    var locationAddress: String?
    var latitude: Double?
    var longitude: Double?
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    
    // data from previous controller
    var shopName: String?
    var shopAddress: String?
    var contactNum: String?
    var shippingAddress: String?
    var password: String?
    var emailAdd: String?
    
    // temp data
    var tempBranchName: String?
    var tempBranchAddress: String?
    var tempBranchPhone: String?
    var tempStoreImg1: UIImageView?
    
    
    var isNewAccount = true
    
    var isEdit = false

    var storeImgList = [UIImageView]()
    var permitImgList = [UIImageView]()

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
        // Do any additional setup after loading the view, typically from a nib.

        // Show Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        branchName.delegate = self
        branchAddress.delegate = self
        phone.delegate = self
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.initTapRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        let desiredOffset = CGPoint(x: 0, y: 0)
        self.addBranchScrollView.setContentOffset(desiredOffset, animated: true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if tempBranchName != nil {
            self.branchName.text = tempBranchName
        }
        if tempBranchAddress != nil {
            self.branchAddress.text = tempBranchAddress
        }
        if tempBranchPhone != nil {
            self.phone.text = tempBranchPhone
        }
        if self.locationAddress != nil {
            self.branchAddress.text = self.locationAddress
            
        }
        
        if isEdit {
            branchName.text = branch.name
            branchAddress.text = branch.address
            phone.text = branch.phone
            storeImg.image = branch.storePhotos[0].image
            storeImg2.image = branch.storePhotos[1].image
            storeImg3.image = branch.storePhotos[2].image
            permitImg.image = branch.permitPhotos[0].image
            permitImg2.image = branch.permitPhotos[1].image
            permitImg3.image = branch.permitPhotos[2].image
            latitude = branch.latitude
            longitude = branch.longitude
            locationAddress = branch.address
            navigationItem.title = "Edit Branch"
            addMapAddressBtn?.setImage(UIImage(named: "ic_mode_edit_black"), for: UIControlState.normal)
        }
    }

    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func searchAddressFromMap(_ sender: AnyObject) {
        performSegue(withIdentifier: "pushToMapSearch", sender: nil)
    }
    
    @IBAction func addBranch(_ sender: Any) {
        if isNewAccount && isComplete() {
            // add validation of fields
            let branch = Branch()
            branch.name = branchName.text!
            branch.address = branchAddress.text!
            branch.phone = phone.text!
            branch.latitude = latitude!
            branch.longitude = longitude!
            branch.storePhotos.append(storeImg)
            branch.storePhotos.append(storeImg2)
            branch.storePhotos.append(storeImg3)
            branch.permitPhotos.append(permitImg)
            branch.permitPhotos.append(permitImg2)
            branch.permitPhotos.append(permitImg3)
            
            let reg = Registration()
            if shopName != nil {
                reg.shopName = shopName!
            } else {
                reg.shopName = ""
            }
            if shopAddress != nil {
                reg.shopAddress = shopAddress!
            } else {
                reg.shopAddress = ""
            }
            if shippingAddress != nil {
                reg.shippingAddress = shippingAddress!
            } else {
                reg.shippingAddress = ""
            }
            if contactNum != nil {
                reg.contactNum = contactNum!
            } else {
                reg.contactNum = ""
            }
            if emailAdd != nil {
                reg.email = emailAdd!
            } else {
                reg.email = ""
            }
            if password != nil {
                reg.password = password!
            } else {
                reg.password = ""
            }
            
            reg.branchModels.append(branch)
            
            performSegue(withIdentifier: "pushToNewAccount", sender: reg)
        } else if isNewAccount == false && isComplete() {
            // TODO: integrate
            // show modal
            registerBranch()
            showModal(title: "Thank you for adding new branch!", msg: "This is pending for approval", isComplete: true)
            
        } else {
            showWarningModal(msg: "Please fill in all the required fields. Make sure to upload one store image and one permit image.")
        }

    }
    
    func showModal(title: String, msg: String, isComplete: Bool){
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { action -> Void in
            if isComplete {
                self.performSegue(withIdentifier: "pushToBranches", sender: nil)
            }
        })
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func isComplete() -> Bool{
        if branchName!.text != "" &&  phone!.text != "" && storeImg.image != nil && permitImg.image != nil && isValidAddress() {
            return true
        }
        
        return false
    }
    
    func isValidAddress() -> Bool {
        if self.locationAddress != nil && self.longitude != nil && self.latitude != nil {
            return true
        }
        
        return false
    }
    
    // Just open gallery
    func tapDetected(full: Bool, sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "pushToMapSearch", let destination = segue.destination as? MapSearchViewController{
            destination.isNewAccount = isNewAccount
            destination.branchName = branchName?.text
            destination.branchAddress = branchAddress?.text
            destination.branchContactNum = phone?.text
            
        } else {
            if isNewAccount , let destination = segue.destination as? NewAccountViewController{
                
                if let reg = sender as? Registration {
                    destination.reg = reg
                    destination.isNewBranchAdded = true
                    destination.storeTmpImg1 = storeImg
                    destination.storeTmpImg2 = storeImg2
                    destination.storeTmpImg3 = storeImg3
                    destination.permitTmpImg1 = permitImg
                    destination.permitTmpImg2 = permitImg2
                    destination.permitTmpImg3 = permitImg3
                    destination.shopNameField?.text = shopName
                    destination.shopAddressField?.text = shopAddress
                    destination.contactNumField?.text = contactNum
                    destination.shippingAddressField?.text = shippingAddress
                    destination.passwordField?.text = password
                    destination.emailAddField?.text = emailAdd
                }
            } else {
                
                let destination = segue.destination as? BranchesViewController
                
                if let branch = sender as? Branch {
                    destination?.branch = branch
                }
            }
        }
        
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        print("unwind segue", self.latitude, self.longitude)
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

    func registerBranch(){
        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false
        
        let branchImage = convertPhotosToBase64()
        
        let branch = Branch()
        branch.name = branchName.text!
        branch.address = branchAddress.text!
        branch.phone = phone.text!
        branch.latitude = latitude!
        branch.longitude = longitude!
        branch.photos = branchImage
        
        postBranch(branchModel: branch, validationCompleted: { (dat, stat) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                
                self.strLabel.isEnabled = false
                
                if stat == 201 {
                    self.showModal(title: "Thank you for adding new branch!", msg: "Branch is pending for approval", isComplete: true)
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

    
    // Used when plus button is clicked
    func tapDetected(sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        var isFullStoreImg = false
        var isFullPermitImg = false
        
        switch tag {
        case 1 :
            print("Tapped add store image button")
            if storeImg?.image == nil {
                imageHere = storeImg
            } else if storeImg2?.image == nil {
                imageHere = storeImg2
            } else if storeImg3?.image == nil{
                imageHere = storeImg3
            } else {
                isFullStoreImg = true
                showWarningModal(msg: "Max of 3 only. Click on the image to replace")
            }
            
            break
        case 2 :
            imageHere = storeImg
            
            break
        
        case 3 :
            imageHere = storeImg2
            
            break

        case 4 :
            imageHere = storeImg3
            
            break
            
        case 5 :
            print("Tapped add permit image button")
            if permitImg.image == nil{
                imageHere = permitImg
            } else if permitImg2.image == nil {
                imageHere = permitImg2
            } else if permitImg3.image == nil{
                imageHere = permitImg3
            } else {
                isFullPermitImg = true
                showWarningModal(msg: "Max of 3 only. Click on the image to replace")
            }
            
            break
            
        case 6 :
            imageHere = permitImg
            
            break
            
        case 7 :
            imageHere = permitImg2
            
            break
            
        case 8 :
            imageHere = permitImg3
            
            break
            
        default:
            break
        }
        
        if (!isFullStoreImg || isFullPermitImg) && UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Modal shown
    func showWarningModal(msg: String){
        let alertController = UIAlertController(title: "Oops!", message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // TapGesture function when added image is tapped
    func imageTapped(_ sender: UITapGestureRecognizer) {
        imageHere = sender.view as? UIImageView
        newImageView = UIImageView(image: imageHere?.image)
        newImageView?.frame = self.view.frame
        newImageView?.backgroundColor = UIColor.black
        newImageView?.contentMode = .scaleAspectFit
        newImageView?.isUserInteractionEnabled = true
        
        // Add right nav bar button for replacing image
        let add = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapDetected(full:sender:)))
        
        navigationItem.rightBarButtonItems = [add]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.dismissFullscreenImage(_:)))
        newImageView?.addGestureRecognizer(tap)
        
        // Update title and hide back button
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "View / Replace Image"
        self.view.addSubview(newImageView!)
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer? = nil) {
        sender?.view?.removeFromSuperview()

        // Revert title, show back button, hide plus button
        updateNavItems()
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        self.dismiss(animated: true, completion: nil);

        // Enable User interaction once an image is added
        imageHere?.isUserInteractionEnabled = true
        imageHere?.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)

        // Remove image view to go diretly to add branch view
        newImageView?.removeFromSuperview()
        
        // Revert title, show back button, hide plus button
        updateNavItems()
    }

    func updateNavItems(){
        
        let backItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBranch(_:)))
//        backItem.title = "Add"
        navigationItem.rightBarButtonItem = backItem
        
//        navigationItem.rightBarButtonItem?.title = "Add"
        navigationItem.title = "Add Main Branchhhh"
        navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.contentView.endEditing(true)
        self.addBranchScrollView.endEditing(true)
    }

    func initTapRecognizers(){
        
        let addStoreImagetap = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.tapDetected(sender:)))
        addStoreImagetap.numberOfTapsRequired = 1
        addStoreImageBtn.addGestureRecognizer(addStoreImagetap)
        addStoreImageBtn.tag = 1
        
        let storeImagetap = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.imageTapped(_:)))
        storeImagetap.numberOfTapsRequired = 1
        storeImg.addGestureRecognizer(storeImagetap)
        storeImg.tag = 2
        
        let storeImagetap2 = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.imageTapped(_:)))
        storeImagetap2.numberOfTapsRequired = 1
        storeImg2.addGestureRecognizer(storeImagetap2)
        storeImg2.tag = 3
        
        let storeImagetap3 = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.imageTapped(_:)))
        storeImagetap3.numberOfTapsRequired = 1
        storeImg3.addGestureRecognizer(storeImagetap3)
        storeImg3.tag = 4
        
        let addPermitImagetap = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.tapDetected(sender:)))
        addPermitImagetap.numberOfTapsRequired = 1
        addPermitImageBtn.addGestureRecognizer(addPermitImagetap)
        addPermitImageBtn.tag = 5
        
        let permitImagetap = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.imageTapped(_:)))
        permitImagetap.numberOfTapsRequired = 1
        permitImg.addGestureRecognizer(permitImagetap)
        permitImg.tag = 6
        
        let permitImagetap2 = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.imageTapped(_:)))
        permitImagetap2.numberOfTapsRequired = 1
        permitImg2.addGestureRecognizer(permitImagetap2)
        permitImg2.tag = 7
        
        let permitImagetap3 = UITapGestureRecognizer(target: self, action: #selector(AddBranchViewController.imageTapped(_:)))
        permitImagetap3.numberOfTapsRequired = 1
        permitImg3.addGestureRecognizer(permitImagetap3)
        permitImg3.tag = 8
    }
    

}
