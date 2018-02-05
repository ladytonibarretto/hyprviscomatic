//
//  NotificationPost.swift
//  Reseller
//
//  Created by Lady Barretto on 04/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class NotificationPost {
    private var _notifTitle: String!
    private var _notifBody: String!
    private var _status: String!
    
    var notifTitle: String {
        return _notifTitle
    }
    
    var notifBody: String {
        return _notifBody
    }
    
    var status: String {
        return _status
    }
    
    init(notifTitle: String, notifBody: String, status: String) {
        
        _notifTitle = notifTitle
        _notifBody = notifBody
        _status = status
    }
}
