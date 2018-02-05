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
        set { _url = newValue }
        get { return _url }
    }
    
    var integerBase: [Int] {
        set { _integerBase = newValue }
        get { return _integerBase }
    }
    
    var stringBase: [String] {
        set { _stringBase = newValue }
        get { return _stringBase }
    }

    var imageCount: UInt {
        set { _imageCount = newValue }
        get { return _imageCount }
    }

}
