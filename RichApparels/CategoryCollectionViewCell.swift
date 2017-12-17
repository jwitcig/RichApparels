//
//  CategoryCollectionViewCell.swift
//  RichApparels
//
//  Created by Developer on 7/22/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

