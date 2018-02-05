//
//  ImageController.swift
//  Hyprviscomatic
//
//  Created by Lady Barretto on 03/12/2017.
//  Copyright © 2017 Lady Toni Barretto. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

class UploadImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var deleteButton1: UIButton!
    @IBOutlet weak var deleteButton2: UIButton!
    @IBOutlet weak var addImageBtn: UIButton!
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    
    // Used to pass image from PaymentMethod Controller
    var depImage = UIImage()
    var id = String()
    var discount = 0.0
    
    var activeImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        
        imageView.image = depImage
        deleteButton1.isHidden = true
        deleteButton2.isHidden = true

        self.initTapRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    @IBAction func saveImages(_ sender: Any) {
        let receipt = convertPhotosToBase64()
        
        progressBarDisplayer(msg: "Loading...")
        self.view.isUserInteractionEnabled = false
        putPurchaseDetails(id: self.id, receipt: receipt, completionHandler: { (dat, stat) -> Void in
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
    
    func openGallery(sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        // if sender is not add button
        if sender.view!.tag != 1{
            activeImageView = (sender.view as? UIImageView)!
        } else {
            if imageView.image != nil{
                imageView2.image = nil
                imageView2.isHidden = false
                activeImageView = imageView2
            } else {
                activeImageView = imageView
            }
            addImageBtn.isHidden = true
        }
    }
    
    @IBAction func deleteImageView(_ sender: Any) {
        imageView.image = imageView2.image
        imageView2.isHidden = true
    
        setupDelButtons()
        addImageBtn.isHidden = false
    }
    @IBAction func deleteImageView2(_ sender: Any) {
        imageView2.isHidden = true
        
        setupDelButtons()
        addImageBtn.isHidden = false
    }
    
    func setupDelButtons(){
        if imageView.isHidden == false{
            deleteButton1.isHidden = false
        } else {
            deleteButton1.isHidden = true
        }
        if imageView2.isHidden == false{
            deleteButton2.isHidden = false
        } else {
            deleteButton2.isHidden = true
            deleteButton1.isHidden = true
        }
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil);
        
        activeImageView.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        
        setupDelButtons()
    }

    
    func initTapRecognizers(){
        let addButtonImageTap = UITapGestureRecognizer(target: self, action: #selector(ImageController.openGallery(sender:)))
        addButtonImageTap.numberOfTapsRequired = 1
        addImageBtn.addGestureRecognizer(addButtonImageTap)
        addImageBtn.tag = 1
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(ImageController.openGallery(sender:)))
        imageViewTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(imageViewTap)
        imageView.tag = 2
        
        let imageViewTap2 = UITapGestureRecognizer(target: self, action: #selector(ImageController.openGallery(sender:)))
        imageViewTap2.numberOfTapsRequired = 1
        imageView2.addGestureRecognizer(imageViewTap2)
        imageView2.tag = 3
    }
    
    func convertPhotosToBase64() -> ImageModel {
        
        let image = ImageModel()
        var stringBaseList = [String]()
        
        if imageView.isHidden == false {
            let imgString = getEncodedString(imgView: imageView.image!)
            stringBaseList.append(imgString)
        }
        if imageView2.isHidden == false {
            let imgString = getEncodedString(imgView: imageView2.image!)
            stringBaseList.append(imgString)
        }
        
        image.stringBase = stringBaseList
        
        return image
        
    }
    
    func getEncodedString(imgView: UIImage) -> String {
        let imgData = UIImageJPEGRepresentation((imgView), 0.5)
        var imgString = imgData?.base64EncodedString(options:Data.Base64EncodingOptions(rawValue: UInt(0)))
        
        imgString = "data:image/jpeg;base64," + imgString!
        
        return imgString!
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
