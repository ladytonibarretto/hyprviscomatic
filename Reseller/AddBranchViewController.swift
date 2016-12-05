//
//  AddBranchViewController.swift
//  Reseller
//
//  Created by Lady Toni Barretto on 10/18/16.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

import UIKit

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
    
    var isNewAccount = true

    
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
        
        print(addStoreImageBtn.frame.origin.y)
        print(addBranchScrollView.frame.size.height)
        print(addBranchScrollView.frame.size.width)
        
        // For right bar button items
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "imagename"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "imagename"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let item2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
        
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
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func searchAddressFromMap(_ sender: AnyObject) {
//        performSegue(withIdentifier: "pushToMapSearch", sender: nil)
    }
    
    @IBAction func submitBranch(_ sender: AnyObject) {
        // add validation of fields
        let branch = Branch()
        branch.name = branchName.text!
        branch.address = branchAddress.text!
        branch.phone = phone.text!
        
        if isNewAccount && isComplete() {
            performSegue(withIdentifier: "pushToNewAccount", sender: branch)
        } else if isNewAccount == false && isComplete() {
            performSegue(withIdentifier: "pushToBranches", sender: branch)
        } else {
            showWarningModal(msg: "Please fill in all the required fields. Make sure to upload one store image and one permit image.")
        }
    }
    
    func isComplete() -> Bool{
        if self.locationAddress == nil && branchName!.text != "" &&  phone!.text != "" && storeImg.image != nil && permitImg != nil {
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
        print("segueeee", segue.identifier!)
        
        if segue.identifier! == "pushToMapSearch", let destination = segue.destination as? MapSearchViewController{
            destination.isNewAccount = isNewAccount
        } else {
            if isNewAccount , let destination = segue.destination as? NewAccountViewController{
                
                if let branch = sender as? Branch {
                    destination.branch = branch
                    destination.isNewBranchAdded = true
                    destination.storeTmpImg1 = storeImg.image
                    destination.storeTmpImg2 = storeImg2.image
                    destination.storeTmpImg3 = storeImg3.image
                    destination.permitTmpImg1 = permitImg.image
                    destination.permitTmpImg2 = permitImg2.image
                    destination.permitTmpImg3 = permitImg3.image
                    
                }
            } else {
                
                let destination = segue.destination as? BranchesViewController
                
                if let branch = sender as? Branch {
                    destination?.branch = branch
                }
            }
        }
        
    }

    
    // Used when plus button is clicked
    func tapDetected(sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        var isFullStoreImg = false
        var isFullPermitImg = false
        
        switch tag {
        case 1 :
            print("Tapped add store image button")
            if storeImg.image == nil{
                print("storeImg not niiiiil")
                imageHere = storeImg
            } else if storeImg2.image == nil {
                imageHere = storeImg2
            } else if storeImg3.image == nil{
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
    
    // Modal shown if user already added 3 images
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
        navigationItem.rightBarButtonItems = nil
        navigationItem.title = "Add Main Branch"
        navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        let desiredOffset = CGPoint(x: 0, y: 0)
        self.addBranchScrollView.setContentOffset(desiredOffset, animated: true)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // self.branchAddress.text = self.locationAddress -> used for maps (TODO)
        
        // Hide temporarily since map is not usable
        self.addMapAddressBtn.isHidden = true
        self.addMapAddressLabel.isHidden = true
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

    
}
