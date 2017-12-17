//
//  SecondViewController.swift
//  RichApparels
//
//  Created by Developer on 7/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit
import WebKit

import Cartography

class WebViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
    
        let scripts: [(String, String)] = [
            ("HideSections", "js"),
        ]
        for script in scripts {
            let scriptURL = Bundle.main.path(forResource: script.0, ofType: script.1)
            let scriptContent = try! String(contentsOfFile: scriptURL!, encoding: String.Encoding.utf8)
            
            let script = WKUserScript(source: scriptContent, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            config.userContentController.addUserScript(script)
        }
        return WKWebView(frame: .zero, configuration: config)
    }()
    
    var allowPageLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        navigationItem.titleView = PaintCodeView {
            RichApparelsStyleKit.drawFAQ(frame: $0, resizing: .aspectFit)
        }
        
        edgesForExtendedLayout = .top
        
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        constrain(webView, view) {
            $0.leading == $1.leading
            $0.trailing == $1.trailing
            $0.top == $1.top
            $0.bottom == $1.bottom
        }
    }
    
    func load(url: URL) {
        allowPageLoad = true
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func load(urlString: String) {
        load(url: URL(string: urlString)!)
    }
    
    @IBAction func backPressed(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        allowPageLoad = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(allowPageLoad ? .allow : .cancel)
    }
}

