//
//  SubmissionsViewController.swift
//  RichApparels
//
//  Created by Developer on 7/25/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import AnimatedTextInput
import Cartography
import FirebaseDatabase
import IQKeyboardManagerSwift
import SCLAlertView
import SwiftDate

class SubmissionsViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    var sendFraction: CGFloat = 0.0
    var sendTimer: Timer?
    var sendAnimationStart: Date!
    
    var textField: AnimatedTextInput!
    
    let characterCountMax = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForm()
        
    }
    
    func configureForm() {
        let roosevelt = PaintCodeView {
            RichApparelsStyleKit.drawRoosevelt(frame: $0, resizing: .aspectFit, rooseveltIcon: #imageLiteral(resourceName: "Roosevelt_Icon"))
        }
        view.addSubview(roosevelt)
        
        constrain(roosevelt, view) {
            $0.width == $1.width * 0.8
            $0.width == $0.height * 716/382.0
            
            $0.centerX == $1.centerX
            $0.centerY == $1.centerY * 0.5
        }
        
        textField = AnimatedTextInput()
        textField.type = .multiline
        textField.placeHolderText = "What's your suggestion?"
        textField.style = CustomTextInputStyle()
        textField.delegate = self
        textField.showCharacterCounterLabel(with: 140)
        view.addSubview(textField)
        
        constrain(textField, view, roosevelt) {
            $0.width == $1.width * 0.8
            
            $0.centerX == $1.centerX
            $0.top == $2.bottom + 20
        }
        
        let send = PaintCodeButton {
            RichApparelsStyleKit.drawSendCircleAnimationCombined(frame: $0, resizing: .aspectFit, sendCompletionFraction: self.sendFraction)
        }
        send.addTarget(self, action: #selector(SubmissionsViewController.sendPressed(sender:)), for: .touchUpInside)
        view.addSubview(send)
        
        constrain(send, textField) {
            $0.width == 80
            $0.width == $0.height * 184/165.0
            
            $0.centerX == $1.centerX
            $0.top == $1.bottom + 20
        }
    }
    
    func sendPressed(sender: UIView) {
        guard let suggestion = textField.text, suggestion.characters.count > 0 else { return }
        
        textField.resignFirstResponder()
        
        guard self.sendTimer == nil else { return }
        
        self.submit(suggestion: suggestion, completionHandler: { success in
            guard success else { return }
            
            let start = Date()
            self.sendAnimationStart = start
            
            self.sendTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {
                
                let time = Date().timeIntervalSince(start)
                let duration = 0.5
                
                self.sendFraction = CGFloat(Easing.easeOutSine(time: time, start: 0, change: 1.0, duration: duration))
                
                if time > duration {
                    $0.invalidate()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            showCloseButton: false
                        )
                        
                        
                        SCLAlertView(appearance: appearance).showTitle("Thanks!",
                                subTitle: "Your ideas are much appreciated!",
                                duration: 2.5,
                                completeText: nil,
                                style: .success,
                                colorStyle: 0xA429FF,
                                colorTextButton: 0xFFFFFF
                        )
                        
                        
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                sender.setNeedsDisplay()
            })
        })
    }
    
    func submit(suggestion: String, completionHandler: @escaping (Bool)->()) {
        let payload: [String : Any] = [
            "body": suggestion,
            "timestamp": Date().string(format: .iso8601(options: .withInternetDateTime)),
        ]
        
        Database.database().reference().child("suggestions").childByAutoId().setValue(payload) { error, reference in
            completionHandler(error == nil)
        }
    }
}

extension SubmissionsViewController: AnimatedTextInputDelegate {
    func animatedTextInputShouldReturn(animatedTextInput: AnimatedTextInput) -> Bool {
        return false
    }
    
    func animatedTextInput(animatedTextInput: AnimatedTextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return (animatedTextInput.text ?? "").characters.count - range.length + string.characters.count <= characterCountMax
    }
}

struct CustomTextInputStyle: AnimatedTextInputStyle {
    let textAttributes: [String : Any]? = nil

    let yPlaceholderPositionOffset: CGFloat = 0
    let lineInactiveColor: UIColor = .black
    let activeColor: UIColor = .white
    let inactiveColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    let errorColor: UIColor = .red
    let textInputFont = UIFont.systemFont(ofSize: 20)
    let textInputFontColor: UIColor = .white
    let placeholderMinFontSize: CGFloat = 9
    let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 9)
    let leftMargin: CGFloat = 0
    let topMargin: CGFloat = 20
    let rightMargin: CGFloat = 0
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = 7
}
