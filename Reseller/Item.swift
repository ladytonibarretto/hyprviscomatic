//
//  Item.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class Item {
    private var _product: Product!
    private var _quantity: UInt!
    
    
    var product: Product
    {
        return _product
    }
    
    var quantity: UInt {
        return _quantity
    }
    
    init(product: Product, quantity: UInt) {
        
        _product = product
        _quantity = quantity
    }
}
