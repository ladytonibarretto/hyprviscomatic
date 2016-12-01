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

func sendRequest(url: String, params: String?=nil, type: String, completedRequest: @escaping (_ dat: Data, _ stat: Int) -> Void ){
    var request = URLRequest(url: URL(string: url)!)
    let postString = params
    var statusCode = 0

    request.httpMethod = type
    request.httpBody = postString?.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // check for fundamental networking error
        guard let data = data, error == nil else {
            print("error=\(error)")
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

func getBranches(validationCompleted: @escaping (_ branches: [JSON]) -> Void) {
    
    let URL = "\(Constants.baseURL)/\(Constants.branchURL)"
    
    var branchList = [JSON]()
    
    sendRequest(url: URL, type: "GET", completedRequest: { (dat, stat) -> Void in
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

