//
//  Order.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class Order {
    private var _id: UInt!
    private var _discount: Double!
    private var _totalPrice: Double!
    private var _status: String!
    private var _items: [Item]!
    
    var id: UInt {
        return _id
    }

    var discount: Double {
        return _discount
    }
    
    var totalPrice: Double {
        return _totalPrice
    }
    
    var status: String {
        return _status
    }

    var items: [Item] {
        return _items
    }

    init(id: UInt, discount: Double, totalPrice: Double, status: String, items: [Item]) {
        
        _id = id
        _discount = discount
        _totalPrice = totalPrice
        _status = status
        _items = items
    }
}
