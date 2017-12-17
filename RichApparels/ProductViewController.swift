//
//  ProductViewController.swift
//  RichApparels
//
//  Created by Developer on 7/23/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import JWSwiftTools

class ProductViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var product: Product! {
        didSet {
            nameLabel.text = product.name
            priceLabel.text = product.defaultPrice
            descriptionLabel.text = product.description
            
            let url = URL(string: product.primaryImageUrl)!
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.sync {
                        self.imageView.image = UIImage(data: data)
                    }
                } catch { }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backPressed(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
