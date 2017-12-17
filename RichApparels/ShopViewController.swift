//
//  ShopViewController.swift
//  RichApparels
//
//  Created by Developer on 7/24/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit
import WebKit

import Cartography

class ShopViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        
        let scripts: [(String, String)] = []
        for script in scripts {
            let scriptURL = Bundle.main.path(forResource: script.0, ofType: script.1)
            let scriptContent = try! String(contentsOfFile: scriptURL!, encoding: String.Encoding.utf8)
            
            let script = WKUserScript(source: scriptContent, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            config.userContentController.addUserScript(script)
        }
        return WKWebView(frame: .zero, configuration: config)
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        constrain(webView, view) {
            $0.leading == $1.leading
            $0.trailing == $1.trailing
            $0.top == $1.top
            $0.bottom == $1.bottom
        }
        
        let request = URLRequest(url: URL(string: Rich.url)!)
        webView.load(request)
    }
    
    @IBAction func backPressed(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ShopViewController: WKNavigationDelegate { }
