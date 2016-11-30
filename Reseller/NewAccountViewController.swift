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
    
    private var _branch: Branch!
    
    var isNewBranchAdded = false
    
    var storeTmpImg1 : UIImage?
    var storeTmpImg2 : UIImage?
    var storeTmpImg3 : UIImage?
    var permitTmpImg1 : UIImage?
    var permitTmpImg2 : UIImage?
    var permitTmpImg3 : UIImage?

    var branch: Branch {
        get {
            return _branch
        } set {
            _branch = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print("1123123123123")
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
