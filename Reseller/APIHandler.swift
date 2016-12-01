//
//  APIHandler.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

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
        print("###########")
        let json = JSON(data: dat)
        print("******DATA")
        print(stat)
        print(json["user"]["username"].stringValue)
        
        validationCompleted(dat, stat)
        
    })
}

func getBranches() -> [Branch]{
    
    let URL = "\(Constants.baseURL)/\(Constants.branchURL)"
//    let response = sendRequest(url: URL, type: "POST")
    
    // Check response status code
//    if response.1 == 200{
//        return []
//    }
    
    return []
}

func getProducts() -> [Product]{
    let URL = "\(Constants.baseURL)/\(Constants.productURL)"
//    let response = sendRequest(url: URL, type: "GET")
    
    print("GETTT PRODUCTS!!!")
    // Check response status code
//    if response.1 == 200{
//        return []
//    }
    
    return []

}

