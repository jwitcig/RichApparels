//
//  ProductImageView.swift
//  RichApparels
//
//  Created by Developer on 7/23/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

@IBDesignable
class ProductImageView: UIView {

    override func draw(_ rect: CGRect) {
        RichApparelsStyleKit.drawProduct(frame: rect, resizing: .stretch)
    }
}
