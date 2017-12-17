//
//  HomeViewController.swift
//  RichApparels
//
//  Created by Developer on 7/24/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Cartography

class HomeViewController: UIViewController {
    
    @IBOutlet weak var modelImageView: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var linksView: HomeLinksView!
    
    let linkTitles = [
        "Shop",
        "Looks",
        "Exclusives",
        "Rich Suggestions",
        "Rich Kids",
        "Press",
        "FAQ",
        "Search"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.makeNavigationBarTransparent()
        
        setupLinks()
        
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        modelImageView.addSubview(visualEffect)
        
        constrain(visualEffect, modelImageView) {
            $0.center == $1.center
            $0.size == $1.size
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func instagramPressed(sender: Any) {
        guard let instagramURL = URL(string: "instagram://user?username=richapparels") else { return }
        
        guard UIApplication.shared.canOpenURL(instagramURL) else { return }
        
        UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
    }
    
    func setupLinks() {
        let titlesAndActions: [(String, ()->())] = linkTitles.map { title in
            (title, {_ = self.performSegueSafely(identifier: title, sender: self)})
        }
        
        linksView.addLinks(titlesAndActions: titlesAndActions)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, let destination = segue.destination as? WebViewController {
            
            destination.navigationItem.title = identifier
            
            if identifier == "Press" {
                destination.load(urlString: Rich.pressUrl)
            } else if identifier == "FAQ" {
                destination.load(urlString: Rich.faqUrl)
            }
        }
    }

}

class HomeLinksView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addLinks(titlesAndActions: [(String, ()->())]) {
        let views = titlesAndActions.map { title, action -> PaintCodeButton in
            let button = PaintCodeButton(drawRect: {
                RichApparelsStyleKit.drawShop(frame: $0, resizing: .aspectFit, buttonTitle: title)
            })
            button.addAction(for: .touchUpInside, action: action)
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        addSubview(stackView)
        constrain(stackView, self) {
            $0.center == $1.center
            $0.size == $1.size
        }
    }
    
}
