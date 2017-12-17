//
//  MoreViewController.swift
//  RichApparels
//
//  Created by Developer on 7/22/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var pressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIButton else { return }
        
        guard let source = segue.source as? MoreViewController else { return }
        guard let destination = segue.destination as? WebViewController else { return }
        
        let url: URL!
        
        switch button {
        case source.faqButton:
            url = URL(string: Rich.faqUrl)
        case source.pressButton:
            url = URL(string: Rich.pressUrl)
        default: fatalError()
        }
        
        destination.load(url: url)
    }
}
