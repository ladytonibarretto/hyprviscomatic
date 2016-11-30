//
//  APIHandler.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

func sendRequest(url: String, params: String?=nil) -> (String, Int){
    var request = URLRequest(url: URL(string: url)!)
    let postString = params
    var responseString = String()
    var statusCode = Int()

    request.httpMethod = Constants.POST
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
        }
        
        responseString = String(data: data, encoding: .utf8)!
        print("responseString = \(responseString)")
    }
    task.resume()
    return (responseString, statusCode)
}


func isValidCredential(username: String, password: String) -> Bool{
    
    let URL = "\(Constants.baseURL)/\(Constants.signInURL)"
    let params = "username=\(username)&password=\(password)"
    let response = sendRequest(url: URL, params: params)
    
    // Check response status code
    if response.1 == 200{
        return true
    }
    
    return true
}

func getBranches() -> [Branch]{
    
    let URL = "\(Constants.baseURL)/\(Constants.branchURL)"
    let response = sendRequest(url: URL)
    
    // Check response status code
    if response.1 == 200{
        return []
    }
    
    return []
}

