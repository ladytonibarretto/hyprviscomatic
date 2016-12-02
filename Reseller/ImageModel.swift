//
//  ImageModel.swift
//  Reseller
//
//  Created by Lady Barretto on 06/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation

class ImageModel {
    private var _url: String!
    private var _integerBase: [Int]!
    private var _stringBase: [String]!
    private var _imageCount: UInt!
    
    var url: String {
        return _url
    }
    
    var integerBase: [Int] {
        return _integerBase
    }
    
    var stringBase: [String] {
        return _stringBase
    }

    var imageCount: UInt {
        return _imageCount
    }

    init(url: String, integerBase: [Int], stringBase: [String], imageCount: UInt) {
        
        _url = url
        _integerBase = integerBase
        _stringBase = stringBase
        _imageCount = imageCount
    }
}
