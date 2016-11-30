//
//  Branch.swift
//  Reseller
//
//  Created by Lady Barretto on 06/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class Branch {
    private var _name: String!
    private var _address: String!
    private var _phone: String!
    private var _latitude: Double!
    private var _longitude: Double!
    private var _photos: ImageModel!
    
    var name: String {
        return _name
    }
    
    var address: String {
        return _address
    }
    
    var phone: String {
        return _phone
    }

    var latitude: Double {
        return _latitude
    }
    
    var longitude: Double {
        return _longitude
    }
    
    var photos: ImageModel {
        return _photos
    }
    
    init(name: String, address: String, phone: String, latitude: Double, longitude: Double) {
        
        _name = name
        _address = address
        _phone = phone
    }
}
