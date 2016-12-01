
//
//  Product.swift
//  Reseller
//
//  Created by Lady Barretto on 06/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class Product {
    private var _id: UInt!
    private var _url: String!
    private var _name: String!
    private var _brand: String!
    private var _price: Double!
    private var _photos: ImageModel!
    private var _productAttr: String! // double check
    private var _quantity: UInt!
    

    var id: UInt {
        return _id
    }
    
    var url: String {
        return _url
    }
    
    var name: String {
        return _name
    }
    
    var brand: String {
        return _brand
    }
    
    var price: Double {
        return _price
    }
    
    var photos: ImageModel {
        return _photos
    }

    var productAttr: String {
        return _productAttr
    }
    
    var quantity: UInt {
        return _quantity
    }
    
    init(name: String) {
        _name = name
//        _brand = brand
//        _price = price
//        _productAttr = productAttr
    }
}
