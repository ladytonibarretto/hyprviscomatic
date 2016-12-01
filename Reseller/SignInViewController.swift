//
//  SignInViewController.swift
//  Reseller
//
//  Created by Lady Toni Barretto on 10/17/16.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

class SingInViewController: UIViewController, UITextFieldDelegate {
    
    var photo: UIImage!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var newAcctBtn: UIButton!
    
    @IBOutlet weak var shopBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements(isEnabled: Bool){
        username.isEnabled = isEnabled
        password.isEnabled = isEnabled
        newAcctBtn.isEnabled = isEnabled
        shopBtn.isEnabled = isEnabled
        loginBtn.isEnabled = isEnabled
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        // show activity indicator (spinner)
        progressBarDisplayer(msg: "Signing In...")
        setElements(isEnabled: false)
        
        // Verify credentials
        isValidCredential(username: username.text!, password: password.text!, validationCompleted: { (dat, stat) -> Void in
                
            DispatchQueue.main.async {
                
                // Remove activity indicator
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.strLabel.isEnabled = false
                    
                // Check credentials based on http status code
                if stat == 200 {
                    self.performSegue(withIdentifier: "pushToDistShop", sender: nil)
                } else if stat == 403 {
                    self.showModal(title: "Invalid Credentials!", msg: "Unable to login with provided credentials")
                } else {
                    self.showModal(title: "Error!", msg: "Unable to login. Please try again later.")
                }
            }
        })
    }
    
    func showModal(title: String, msg: String){
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        self.setElements(isEnabled: true)
    }
    
    func progressBarDisplayer(msg:String) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor(red: 0.902, green: 0.4941, blue: 0.0275, alpha: 1.0)
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
