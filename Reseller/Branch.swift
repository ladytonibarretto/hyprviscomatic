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
        set { _name = newValue }
        get { return _name }
    }
    
    var address: String {
        set { _address = newValue }
        get { return _address }
    }
    
    var phone: String {
        set { _phone = newValue }
        get { return _phone }
    }

    var latitude: Double {
        set { _latitude = newValue }
        get { return _latitude }
    }
    
    var longitude: Double {
        set { _longitude = newValue }
        get { return _longitude }
    }
    
    var photos: ImageModel {
        set { _photos = newValue }
        get { return _photos }
    }
}
