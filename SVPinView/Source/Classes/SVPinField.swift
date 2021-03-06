//
//  SVPinField.swift
//  SVPinView
//
//  Created by Srinivas Vemuri on 20/04/18.
//  Copyright © 2018 Xornorik. All rights reserved.
//

import UIKit

class SVPinField: UITextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUi()
        self.delegate = self
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.delete(_:)) {
            
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        
        let isBackSpace = { () -> Bool in
            let char = self.text!.cString(using: String.Encoding.utf8)!
            return strcmp(char, "\\b") == -92
        }()
        
        if isBackSpace {
            if let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as UIResponder? {
                nextResponder.becomeFirstResponder()
            }
        }
    }
    
    override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        return text.rangeOfCharacter(from: NSCharacterSet.alphanumerics) != nil
    }
    
    
    fileprivate func setupUi() {
        autocapitalizationType = .allCharacters
    }
}

extension SVPinField : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZ0123456789").inverted
        return string.rangeOfCharacter(from: set) == nil
    }
}

