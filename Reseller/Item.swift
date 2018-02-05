//
//  Item.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class NativeItem {
    private var _product: String!
    private var _brand: String!
    private var _productID: UInt!
    private var _brandID: UInt!
    private var _price: Double!
    private var _quantity: UInt!
    private var _attribute_id: UInt!
    
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

    var productID: UInt {
        set { _productID = newValue }
        get { return _productID }
    }

    var brandID: UInt {
        set { _brandID = newValue }
        get { return _brandID }
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

    var attribute_id: UInt {
        set { _attribute_id = newValue }
        get { return _attribute_id }
    }
}
