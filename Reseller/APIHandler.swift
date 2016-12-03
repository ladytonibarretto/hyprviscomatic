//
//  APIHandler.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

func sendRequest(url: String, token: String?=nil, params: String?=nil, type: String, completedRequest: @escaping (_ dat: Data, _ stat: Int) -> Void ){
    var request = URLRequest(url: URL(string: url)!)
    let postString = params
    var statusCode = 0

    request.httpMethod = type
    request.httpBody = postString?.data(using: .utf8)
    if(token != nil) {
        request.setValue((token), forHTTPHeaderField: "Authorization")
    }
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // check for fundamental networking error
        guard let data = data, error == nil else {
            var pangit = Data()
            print("error=\(error)")
            completedRequest(pangit, 1)
            return
        }
        
        // check for http errors
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            statusCode = httpStatus.statusCode
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        } else {
            statusCode = 200
        }
        completedRequest(data, statusCode)
    }
    task.resume()
}


func isValidCredential(username: String, password: String, validationCompleted: @escaping (_ dat: Data, _ stat: Int) -> Void) {
    
    let URL = "\(Constants.baseURL)/login"
    let params = "username=\(username)&password=\(password)"
    
    sendRequest(url: URL, params: params, type: "POST", completedRequest: { (dat, stat) -> Void in
        validationCompleted(dat, stat)
    })
}

func getBranches(token: String,validationCompleted: @escaping (_ branches: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.branchURL)"
    
    var branchList = [JSON]()
    
    sendRequest(url: URL, token: token, type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let branches = result["results"].array{
            for branch in branches {
                branchList.append(branch)
            }
        }
        validationCompleted(branchList)
    })
}


func getProducts(validationCompleted: @escaping (_ products: [JSON]) -> Void) {

    let URL = "\(Constants.baseURL)/\(Constants.productURL)"

    var productList = [JSON]()
    
    sendRequest(url: URL, type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let products = result["results"].array{
            for product in products {
                productList.append(product)
            }
        }
        validationCompleted(productList)
    })
}

func getBrands(id: String, validationCompleted: @escaping (_ brands: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.productURL)/\(id)"
    
    var brandList = [JSON]()
    
    sendRequest(url: URL, type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)

        if let brands = result["attributes"].array{
            for brand in brands {
                print(brand["name"].stringValue)
                brandList.append(brand)
            }
        }
        validationCompleted(brandList)
    })
}

func getNotifications(token: String, validationCompleted: @escaping (_ notifications: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.notificationURL)"
    
    var notificationList = [JSON]()
    
    sendRequest(url: URL, token: token, type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let notifications = result["results"].array{
            for notification in notifications {
                print(notification["title"].stringValue)
                notificationList.append(notification)
            }
        }
        validationCompleted(notificationList)
    })
}

func getOrderHistory(token: String, validationCompleted: @escaping (_ notifications: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.purchaseURL)"
    
    var notificationList = [JSON]()
    
    sendRequest(url: URL, token: token, type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let notifications = result["results"].array{
            for notification in notifications {
                print(notification["title"].stringValue)
                notificationList.append(notification)
            }
        }
        validationCompleted(notificationList)
    })
}

func postRegistration(registrationModel: Registration, validationCompleted: @escaping (_ dat: Data, _ stat: Int) -> Void) {
    let URL = "\(Constants.baseURL)/\(Constants.registrationURL)"
    
    //Registration json body
    let registrationJson:NSMutableDictionary = NSMutableDictionary()
    let shopDetailsJson:NSMutableDictionary = NSMutableDictionary()
    let branchJsonArray:NSMutableArray = NSMutableArray()
    let photosJsonArray:NSMutableArray = NSMutableArray()
    
    shopDetailsJson.setValue(registrationModel.shopName, forKey: "shop_name")
    shopDetailsJson.setValue(registrationModel.contactNum, forKey: "phone")
    shopDetailsJson.setValue(registrationModel.shopAddress, forKey: "shop_address")
    shopDetailsJson.setValue(registrationModel.shippingAddress, forKey: "shipping_address")
    
    
    if(!registrationModel.branchModels.isEmpty) {
        for branchModel in registrationModel.branchModels
        {
            print("with branchhhh", branchModel.name)
            //ARRAY OF STORE PHOTO
            for stringBase in branchModel.photos.stringBase {
                let storePhotoJson:NSMutableDictionary = NSMutableDictionary()
                storePhotoJson.setValue(stringBase, forKey: "image")
                storePhotoJson.setValue("Photo of Permit No. ", forKey: "description")
                photosJsonArray.add(storePhotoJson)
            }
            
            let branchItem: NSMutableDictionary = NSMutableDictionary()
            branchItem.setObject(photosJsonArray, forKey: "photos" as NSCopying)
            branchItem.setValue(branchModel.name, forKey: "name")
            branchItem.setValue("0", forKey: "lat")
            branchItem.setValue("0", forKey: "lng")
            branchItem.setValue(branchModel.phone, forKey: "phone")
            branchItem.setValue(branchModel.address, forKey: "address")
            branchJsonArray.add(branchItem)
        }
    }
    
    registrationJson.setObject(branchJsonArray, forKey: "branches" as NSCopying)
    registrationJson.setValue(registrationModel.email, forKey: "username")
    registrationJson.setValue(registrationModel.password, forKey: "password")
    registrationJson.setObject(shopDetailsJson, forKey: "shop" as NSCopying)
    
    
    
    do {
    
        let data = try JSONSerialization.data(withJSONObject: registrationJson, options: JSONSerialization.WritingOptions.prettyPrinted)

        let params = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
//        print("params*****")
//        
//        print(params)
        
        sendRequest(url: URL, params: params as String?, type: "POST", completedRequest: { (dat, stat) -> Void in
            validationCompleted(dat, stat)
        })
    }catch {
        print(error)
    }
        
    
}

