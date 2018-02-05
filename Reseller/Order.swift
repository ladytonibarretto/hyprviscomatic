//
//  Order.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation
import SwiftyJSON

class Order {
    private var _id: String!
    private var _totalPrice: String!
    private var _discount: String!
    private var _shipping_fee: String!
    private var _status: String!
    private var _dateAdded: Double!
    private var _receipt: String!
    private var _payment_method: String!
    private var _items: [JSON]!
    
    var id: String {
        return _id
    }
    
    var totalPrice: String {
        return _totalPrice
    }

    var discount: String {
        return _discount
    }

    var shipping_fee: String {
        return _shipping_fee
    }

    var status: String {
        return _status
    }

    var receipt: String {
        return _receipt
    }

    var payment_method: String {
        return _payment_method
    }

    var dateAdded: Double {
        return _dateAdded
    }

    var items: [JSON] {
        return _items
    }

    init(id: String, totalPrice: String, discount: String, shipping_fee: String, status: String, dateAdded: Double, receipt: String, payment_method: String, items: [JSON]) {
        
        _id = id
        _totalPrice = totalPrice
        _discount = discount
        _shipping_fee = shipping_fee
        _status = status
        _dateAdded = dateAdded
        _receipt = receipt
        _payment_method = payment_method
        _items = items
    }
}
