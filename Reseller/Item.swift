//
//  Item.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class Item {
    private var _product: String!
    private var _brand: String!
    private var _price: Double!
    private var _quantity: UInt!
    
    var product: String
    {
        set { _product = newValue }
        get { return _product }
    }

    var brand: String
        {
        set { _brand = newValue }
        get { return _brand }
    }

    var price: Double
        {
        set { _price = newValue }
        get { return _price }
    }

    var quantity: UInt {
        set { _quantity = newValue }
        get { return _quantity }
    }
    
    init(product: String, brand: String, price: Double, quantity: UInt) {
        
        _product = product
        _brand = brand
        _price = price
        _quantity = quantity
    }
}
