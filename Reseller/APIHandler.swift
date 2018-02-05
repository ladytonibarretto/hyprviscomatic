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

// Common method for API calls
func sendRequest(url: String?=nil, token: String?=nil, params: String?=nil, type: String, isJson: Bool?=nil, completedRequest: @escaping (_ dat: Data, _ stat: Int) -> Void ){

    var request = URLRequest(url: URL(string: url!)!)
    var statusCode = 0

    request.httpMethod = type
    
    if params != "" {
        let postString = params
        request.httpBody = postString?.data(using: .utf8)
    }
    
    if isJson != nil {
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    }
    
    if(token != nil) {
        request.setValue((token), forHTTPHeaderField: "Authorization")
    }
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // check for fundamental networking error
        guard let data = data, error == nil else {
            print("error=\(error)")
            completedRequest(Data(), 1)
            return
        }
        
        let httpStatus = response as? HTTPURLResponse
        statusCode = (httpStatus?.statusCode)!
        
        // check for http errors
        if httpStatus?.statusCode != 200 || httpStatus?.statusCode != 201 {
            print("statusCode should be 200 or 201, but is \(httpStatus?.statusCode)")
            print("response = \(response)")
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

func getBranches(token: String?=nil, validationCompleted: @escaping (_ branches: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.branchURL)"
    
    ad.branchList.removeAll()
    
    sendRequest(url: URL, token: token, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        getNextBranches(url: result["next"].stringValue, token: token!,  nextResult : result , completionHandler: { (result) -> Void in
        
            validationCompleted(ad.branchList)
        })
    })
}

func getNextBranches(url: String, token: String, nextResult : JSON, completionHandler: @escaping (_ result: JSON) -> Void) {

    if url == "" {
        if let branches = nextResult["results"].array{
            for branch in branches {
                ad.branchList.append(branch)
            }
        }
        completionHandler(nextResult)
    } else {
        if let branches = nextResult["results"].array{
            for branch in branches {
                ad.branchList.append(branch)
            }
        }
        
        sendRequest(url: url, token: token, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
            let result = JSON(data: dat)
            
            getNextBranches(url: result["next"].stringValue, token: token, nextResult : result , completionHandler:completionHandler)
        
        })
    }
}

func getProducts(validationCompleted: @escaping (_ products: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.brandURL)"
    
    var productList = [JSON]()
    
    sendRequest(url: URL, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let products = result["results"].array{
            for product in products {
                productList.append(product)
            }
        }
        validationCompleted(productList)
    })
}

func getPurchases(token: String?=nil, validationCompleted: @escaping (_ branches: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.purchaseURL)"
    
    ad.purchaseList.removeAll()
    
    sendRequest(url: URL, token: token, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        getNextPurchases(url: result["next"].stringValue, token: token!,  nextResult : result , completionHandler: { (result) -> Void in
            
            validationCompleted(ad.purchaseList)
        })
    })    
}

func getNextPurchases(url: String, token: String, nextResult : JSON, completionHandler: @escaping (_ result: JSON) -> Void) {
    
    if url == "" {
        if let purchases = nextResult["results"].array{
            for purchase in purchases {
                ad.purchaseList.append(purchase)
            }
        }
        completionHandler(nextResult)
    } else {
        if let purchases = nextResult["results"].array{
            for purchase in purchases {
                ad.purchaseList.append(purchase)
            }
        }
        
        sendRequest(url: url, token: token, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
            let result = JSON(data: dat)
            
            getNextPurchases(url: result["next"].stringValue, token: token, nextResult : result , completionHandler:completionHandler)
            
        })
    }
}

func getBrands(token: String, id: String, validationCompleted: @escaping (_ brands: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.brandURL)/\(id)"
    
    var brandList = [JSON]()
    
    sendRequest(url: URL, token: token, params: "", type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)

        if let brands = result["attributes"].array{
            for brand in brands {
                brandList.append(brand)
            }
        }
        validationCompleted(brandList)
    })
}

func getNotifications(token: String, validationCompleted: @escaping (_ notifications: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.notificationURL)"
    
    var notificationList = [JSON]()
    
    sendRequest(url: URL, token: token, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let notifications = result["results"].array{
            for notification in notifications {
                notificationList.append(notification)
            }
        }
        validationCompleted(notificationList)
    })
}

func getOrderHistory(token: String, validationCompleted: @escaping (_ notifications: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.purchaseURL)"
    
    var orderList = [JSON]()
    
    sendRequest(url: URL, token: token, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let orders = result["results"].array{
            for order in orders {
                orderList.append(order)
            }
        }
        validationCompleted(orderList)
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
            //array of photo
            for stringBase in branchModel.photos.stringBase {
                let storePhotoJson:NSMutableDictionary = NSMutableDictionary()
                storePhotoJson.setValue(stringBase, forKey: "image")
                storePhotoJson.setValue("Branch Photo", forKey: "description")
                photosJsonArray.add(storePhotoJson)
            }
            
            let branchItem: NSMutableDictionary = NSMutableDictionary()
            branchItem.setObject(photosJsonArray, forKey: "photos" as NSCopying)
            branchItem.setValue(branchModel.name, forKey: "name")
            branchItem.setValue(branchModel.latitude, forKey: "lat")
            branchItem.setValue(branchModel.longitude, forKey: "lng")
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

        let params = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        
        sendRequest(url: URL, params: params as String, type: "POST", isJson: true, completedRequest: { (dat, stat) -> Void in validationCompleted(dat, stat)
        })
    }catch {
        print(error)
    }
}

func postBranch(branchModel: Branch, validationCompleted: @escaping (_ dat: Data, _ stat: Int) -> Void) {
    let URL = "\(Constants.baseURL)/\(Constants.branchURL)"
    
    //Branch json body
    let photosJsonArray:NSMutableArray = NSMutableArray()
    
    //array of photo
    for stringBase in branchModel.photos.stringBase {
        let storePhotoJson:NSMutableDictionary = NSMutableDictionary()
        storePhotoJson.setValue(stringBase, forKey: "image")
        storePhotoJson.setValue("Image", forKey: "description")
        photosJsonArray.add(storePhotoJson)
    }
    
    let branchItem: NSMutableDictionary = NSMutableDictionary()
    branchItem.setObject(photosJsonArray, forKey: "photos" as NSCopying)
    branchItem.setValue(ad.username, forKey: "user")
    branchItem.setValue(branchModel.name, forKey: "name")
    branchItem.setValue(branchModel.latitude, forKey: "lat")
    branchItem.setValue(branchModel.longitude, forKey: "lng")
    branchItem.setValue(branchModel.phone, forKey: "phone")
    branchItem.setValue(branchModel.address, forKey: "address")
    
    do {
        
        let data = try JSONSerialization.data(withJSONObject: branchItem, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let params = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        
        sendRequest(url: URL, token: ad.token, params: params as String, type: "POST", isJson: true, completedRequest: { (dat, stat) -> Void in validationCompleted(dat, stat)
        })
    }catch {
        print(error)
    }
}

func postPurchase(discount: Double, orders: [NativeItem], validationCompleted: @escaping (_ dat: Data, _ stat: Int) -> Void) {
    let URL = "\(Constants.baseURL)/\(Constants.purchaseURL)"
    
    //Branch json body
    let orderArray:NSMutableArray = NSMutableArray()
    let orderJson:NSMutableDictionary = NSMutableDictionary()
    var totalAmount = 0.0
    
    //array of photo
    for order in orders{
        let orderItem: NSMutableDictionary = NSMutableDictionary()
        orderItem.setValue(String(order.productID), forKey: "brand")
        orderItem.setValue(String(order.brandID), forKey: "product")
        orderItem.setValue(order.price, forKey: "price")
        orderItem.setValue(order.quantity, forKey: "quantity")
        orderItem.setValue(String(order.attribute_id), forKey: "attribute_id")
        totalAmount = totalAmount + order.price * Double(order.quantity)
        orderArray.add(orderItem)
    }
    
    var emptyArr = [AnyObject]()
    
    let discountAmt = totalAmount * (discount / 100)
    totalAmount = totalAmount - discountAmt
    orderJson.setObject(orderArray, forKey: "items" as NSCopying)
    orderJson.setValue(emptyArr, forKey: "receipt")
    orderJson.setValue("", forKey: "payment_method")
    orderJson.setValue(discount, forKey: "discount")
    orderJson.setValue(totalAmount, forKey: "total")

    do {
        
        let data = try JSONSerialization.data(withJSONObject: orderJson, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let params = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                
        sendRequest(url: URL, token: ad.token, params: params as String, type: "POST", isJson: true, completedRequest: { (dat, stat) -> Void in validationCompleted(dat, stat)
        })
    }catch {
        print(error)
    }
}

func putPurchaseDetails(id: String, receipt: ImageModel?=nil, completionHandler: @escaping (_ details: Data, _ stat: Int) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.paymentURL)/\(id)"

    let purchaseDetails:NSMutableDictionary = NSMutableDictionary()
    let photosJsonArray:NSMutableArray = NSMutableArray()
    
    // bank deposit
    if receipt != nil {
        //array of photo
        for stringBase in (receipt?.stringBase)! {
            let receiptPhotos:NSMutableDictionary = NSMutableDictionary()
            receiptPhotos.setValue(stringBase, forKey: "image")
            receiptPhotos.setValue("Bank Deposit Slip", forKey: "description")
            photosJsonArray.add(receiptPhotos)
        }
        
        purchaseDetails.setValue("bank_deposit", forKey: "payment_method")
        purchaseDetails.setObject(photosJsonArray, forKey: "receipt" as NSCopying)
    } else { // cod
        purchaseDetails.setValue("cod", forKey: "payment_method")
        purchaseDetails.setObject([], forKey: "receipt" as NSCopying)
    }
    
    do {
            
        let data = try JSONSerialization.data(withJSONObject: purchaseDetails, options: JSONSerialization.WritingOptions.prettyPrinted)

        let params = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!

        print(params)
        sendRequest(url: URL, token: ad.token, params: params as String, type: "PUT", isJson: true, completedRequest: { (dat, stat) -> Void in completionHandler(dat, stat)
        })
    }catch {
        print(error)
    }
}

// Get discount per user, depending on token
func getDiscount(validationCompleted: @escaping (_ dat: Double, _ stat: Int) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.discountURL)"
    
    var discountAmount = 0.0
    
    sendRequest(url: URL, token: ad.token, params:"", type: "GET", completedRequest: { (dat, stat) -> Void in
        let result = JSON(data: dat)
        
        if let discounts = result["results"].array{
            for discount in discounts {
                discountAmount = discountAmount + discount["value"].double!
            }
        }
        
        validationCompleted(Double(discountAmount), stat)
    })
}


