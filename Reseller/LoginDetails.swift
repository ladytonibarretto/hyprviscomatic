//
//  LoginDetails.swift
//  Reseller
//
//  Created by Lady Barretto on 06/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class LoginDetails {
    private var _username: String!
    private var _password: String!
    
    var name: String {
        return _username
    }
    
    var address: String {
        return _password
    }
    
    init(username: String, password: String) {
        _username = username
        _password = password
    }
}
