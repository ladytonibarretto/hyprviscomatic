//
//  User.swift
//  Reseller
//
//  Created by Lady Barretto on 06/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class User {
    private var _name: String!
    private var _address: String!
    private var _contactNum: String!
    
    var name: String {
        return _name
    }
    
    var address: String {
        return _address
    }
    
    var contactNum: String {
        return _contactNum
    }
    
    init(name: String, address: String, contactNum: String) {
        
        _name = name
        _address = address
        _contactNum = contactNum
    }
}
