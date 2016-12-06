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
    private var _status: String!
    private var _dateAdded: String!
    private var _items: [JSON]!
    
    var id: String {
        return _id
    }
    
    var totalPrice: String {
        return _totalPrice
    }
    
    var status: String {
        return _status
    }

    var dateAdded: String {
        return _dateAdded
    }

    var items: [JSON] {
        return _items
    }

    init(id: String, totalPrice: String, status: String, dateAdded: String, items: [JSON]) {
        
        _id = id
        _totalPrice = totalPrice
        _status = status
        _dateAdded = dateAdded
        _items = items
    }
}
