//
//  Extensions.swift
//  RichApparels
//
//  Created by Developer on 7/23/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class ClosureSleeve {
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControlEvents, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}

extension UIViewController {
    func canPerformSegue(identifier: String) -> Bool {
        guard let segues = value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        let filtered = segues.filter({ $0.value(forKey: "identifier") as? String == identifier })
        return filtered.count > 0
    }
    
    func performSegueSafely(identifier: String, sender: AnyObject?) -> Bool {
        if canPerformSegue(identifier: identifier) {
            self.performSegue(withIdentifier: identifier, sender: sender)
            return true
        }
        return false
    }
}

extension UINavigationController {
    func makeNavigationBarTransparent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
        navigationBar.backgroundColor = .clear
    }
}
