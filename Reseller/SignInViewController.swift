//
//  SignInViewController.swift
//  Reseller
//
//  Created by Lady Toni Barretto on 10/17/16.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

import UIKit

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
    
    func progressBarDisplayer(msg:String) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor(red: 0.902, green: 0.4941, blue: 0.0275, alpha: 1.0)
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.5)
//        if indicator {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
//        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        makeGetCall()
//        postReq()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setElements(isEnabled: Bool){
        username.isEnabled = isEnabled
        password.isEnabled = isEnabled
        newAcctBtn.isEnabled = isEnabled
        shopBtn.isEnabled = isEnabled
        loginBtn.isEnabled = isEnabled
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        
        if (username.text?.characters.count)! < 4 {
            let alertController = UIAlertController(title: "Invalid!", message:
                "Username must be greater than 4 characters", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (password.text?.characters.count)! < 8 {
            let alertController = UIAlertController(title: "Invalid!", message:
                "Password must be greater than 8 characters", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            // verify username and password
            
            let isValid = isValidCredential(username: username.text!, password: password.text!)
            
            progressBarDisplayer(msg: "Signing In...")
            setElements(isEnabled: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.strLabel.isEnabled = false
                if isValid {
                    self.performSegue(withIdentifier: "pushToDistShop", sender: nil)
                } else {
                    
                    let alertController = UIAlertController(title: "Invalid Credentials!", message:
                        "Unable to login with provided credentials", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.setElements(isEnabled: true)
                }
                
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
