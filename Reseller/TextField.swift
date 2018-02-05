//
//  TextField.swift
//  Hyprviscomatic
//
//  Created by Lady Barretto on 28/08/2017.
//  Copyright © 2017 Lady Toni Barretto. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TextField: UITextField {
    
    var textFieldBorderStyle: UITextBorderStyle = .roundedRect
    
    let fieldPadding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, fieldPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, fieldPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, fieldPadding)
    }
    
}
