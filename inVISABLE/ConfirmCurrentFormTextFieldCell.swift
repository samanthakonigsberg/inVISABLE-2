//
//  ConfirmCurrentFormTextFieldCell.swift
//  inVISABLE
//
//  Created by Angelica Bato on 10/21/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import SwiftForms

extension FormTextFieldCell {
    
}

class ConfirmCurrentFormTextFieldCell: FormTextFieldCell {
    
    override func configure() {
        super.configure()
        
    }
    
    override func update() {
        super.update()
        textField.textAlignment = .right
        if let type = rowDescriptor?.type {
            if type == .password {
                titleLabel.font = UIFont(name: "Rucksack-Demi", size: 18.0)
                textField.font = UIFont(name: "Rucksack-Book", size: 16.0)
            } else if type == .multilineText {
                let desc = UIFontDescriptor(name: "Rucksack-Light", size: 16.0)
                titleLabel.font = UIFont(descriptor: desc, size: 16.0)
                titleLabel.textColor = UIColor.lightGray
            } else if type == .button {
                titleLabel.tintColor = UIColor(named: "ActionNew")
            }
        }
    }
    
    open override func constraintsViews() -> [String : UIView] {
        var views = ["titleLabel" : titleLabel, "textField" : textField]
        if self.imageView!.image != nil {
            views["imageView"] = imageView
        }
        return views
    }
    
    open override func defaultVisualConstraints() -> [String] {
        if self.imageView!.image != nil {
            if titleLabel.text != nil && (titleLabel.text!).count > 0 {
                return ["H:[imageView]-[titleLabel]-[textField]-16-|"]
            } else {
                return ["H:[imageView]-[textField]-16-|"]
            }
        } else {
            if titleLabel.text != nil && (titleLabel.text!).count > 0 {
                return ["H:|-16-[titleLabel]-[textField]-16-|"]
            } else {
                return ["H:|-16-[textField]-16-|"]
            }
        }
    }
    
    @objc func editingEnded(_ sender: UITextField) {
    }

}

