//
//  FirstViewController.swift
//  RichApparels
//
//  Created by Developer on 7/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Alamofire

import JWSwiftTools

class Rich {
    static let api = RichAPI()
    
    static let url = "https://richapparels.bigcartel.com"
    
    static let faqUrl = Rich.url + "/faq"
    static let pressUrl = Rich.url + "/press"

}

class RichAPI {
    var headers: HTTPHeaders = [
        "User-Agent" : "Jwitcig (jwitcig@gmail.com)",
        "Accept" : "application/vnd.api+json"
    ]
    
    let clientKey = "jwitcig"
    let secretKey = "Witcig97"
    
    static let storeAccountID = "3650396"

    let url = "https://api.bigcartel.com/v1"
    
    func accountUrl(accountID: String) -> String {
        return url + "/accounts/" + accountID
    }
    
    func productsUrl(accountID: String, inCategories categoryIDs: [String]? = nil) -> String {
        if let ids = categoryIDs {
            return url + "/accounts/\(accountID)/products?filter[category_id]=\(ids.joined(separator: ","))"
        }
        return url + "/accounts/\(accountID)/products"
    }
    
    func categoriesUrl(accountID: String) -> String {
        return url + "/accounts/\(accountID)/categories"
    }
    
    private func payloadFrom(response: DataResponse<Any>) -> [String : Any]? {
        return response.result.value as? [String : Any]
    }
    
    func productsList(accountID: String = storeAccountID, forCategoryIDs categoryIDs: [String]? = nil, completionHandler: @escaping ([Product]?, Error?) -> ()) {
        
        Alamofire.request(Rich.api.productsUrl(accountID: accountID, inCategories: categoryIDs), headers: Rich.api.headers)
            .authenticate(user: Rich.api.clientKey, password: Rich.api.secretKey)
            .responseJSON { response in
                
                var products: [Product]?
                
                defer {
                    completionHandler(products, response.error)
                }
                
                guard response.error == nil else { return }
                
                guard let productsJSON = self.payloadFrom(response: response)?["data"] as? [[String : Any]] else { return }
                
                products = productsJSON.map{ Product(json: $0)! }
        }
    }
    
    func categoriesList(accountID: String = storeAccountID, completionHandler: @escaping ([Category]?, Error?) -> ()) {
        
        Alamofire.request(Rich.api.categoriesUrl(accountID: accountID), headers: Rich.api.headers)
            .authenticate(user: Rich.api.clientKey, password: Rich.api.secretKey)
            .responseJSON { response in
                
                var categories: [Category]?
                
                defer {
                    completionHandler(categories, response.error)
                }
                
                guard response.error == nil else { return }
                
                guard let categoriesJSON = self.payloadFrom(response: response)?["data"] as? [[String : Any]] else { return }
                
                categories = categoriesJSON.map{ Category(json: $0)! }
        }
    }
}

struct Product {
    let json: [String : Any]
    let attributes: [String : Any]
    
    var id: String { return json["id"] as! String }
    var name: String { return attributes["name"]! as! String }
    var permalink: String { return attributes["permalink"]! as! String }
    var status: String { return attributes["status"]! as! String }
    var description: String { return attributes["description"]! as! String }
    var defaultPrice: String { return attributes["default_price"]! as! String }
    var on_sale: Bool { return attributes["on_sale"]! as! Bool }
    var position: Int { return attributes["position"]! as! Int }
    var url: String { return attributes["url"]! as! String }
    var primaryImageUrl: String { return attributes["primary_image_url"]! as! String }
    var created_at: String { return attributes["created_at"]! as! String }
    var updated_at: String { return attributes["updated_at"]! as! String }
    
    init?(json: [String : Any]) {
        self.json = json
        
        guard let attributes = json["attributes"] as? [String : Any] else {
            return nil
        }
        self.attributes = attributes
    }
}

struct Category {
    let json: [String : Any]
    let attributes: [String : Any]
    
    var id: String { return json["id"] as! String }
    var name: String { return attributes["name"]! as! String }
    var permalink: String { return attributes["permalink"]! as! String }
    var position: Int { return attributes["position"]! as! Int }
    
    init?(json: [String : Any]) {
        self.json = json
        
        guard let attributes = json["attributes"] as? [String : Any] else {
            return nil
        }
        self.attributes = attributes
    }
}

class ProductsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [Product] = []
    var categories: [Category] = []
    
    var categoryID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Rich.api.productsList(forCategoryIDs: categoryID != nil ? [categoryID!] : nil) { products, error in
            self.products = products ?? []
            
            guard error == nil else {
                print(error!)
                return
            }
            
            self.collectionView.reloadData()
        }
    }
}

extension ProductsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard indexPath.row != 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCollectionViewCell

            cell.imageView.image = #imageLiteral(resourceName: "richybanner")
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        
        let product = products[indexPath.row - 1]
        
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.defaultPrice
        
        let imageURL = URL(string: product.primaryImageUrl)
        
        DispatchQueue.global().async {
            let imageData = try! Data(contentsOf: imageURL!)
            
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: imageData)
            }
        }

        return cell
    }
}

extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else { return }
//        
//        present(viewController, animated: true, completion: nil)
//        
//        viewController.product = products[indexPath.row - 1]
        
        
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
        
        present(viewController, animated: true, completion: nil)
        
        viewController.load(url: URL(string: products[indexPath.row - 1].url)!)
        
        
    }
}

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        switch indexPath.row {
        case 0: return CGSize(width: collectionView.frame.width, height: 160)
        default: return CGSize(width: 120, height: 160)
        }
    }
}
