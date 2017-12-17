//
//  CategoriesTableViewController.swift
//  RichApparels
//
//  Created by Developer on 7/22/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Rich.api.categoriesList() { categories, error in
            self.categories = categories ?? []
            
            guard error == nil else {
                print(error)
                return
            }
            
            for x in categories! {
                print(x.id)
            }
        }
    }
}

extension CategoriesViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.row]
        cell.nameLabel.text = category.name
        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController else { return }
        let selected = categories[indexPath.row]
        
        viewController.categoryID = selected.id
        
        present(viewController, animated: true, completion: nil)
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}
