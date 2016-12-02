//
//  Registration.swift
//  Reseller
//
//  Created by Cicciolina Miranda on 12/2/16.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class Registration {
    private var _shopName: String!
    private var _shopAddress: String!
    private var _contactNum: String!
    private var _shippingAddress: String!
    private var _email: String!
    private var _password: String!
    private var _branchModels = [Branch]()
    
    var shopName : String {
        set { _shopName = newValue }
        get { return _shopName }
    }
    
    var shopAddress : String {
        set { _shopAddress = newValue }
        get { return _shopAddress }
    }
    
    var contactNum : String {
        set { _contactNum = newValue }
        get { return _contactNum }
    }

    var shippingAddress : String {
        set { _shippingAddress = newValue }
        get { return _shippingAddress }
    }
    
    var email : String {
        set { _email = newValue }
        get { return _email }
    }
    
    var password : String {
        set { _password = newValue }
        get { return _password }
    }
    
    var branchModels : [Branch] {
        set { _branchModels = newValue }
        get { return _branchModels }
    }
    
}
