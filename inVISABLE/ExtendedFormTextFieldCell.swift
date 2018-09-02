//
//  ExtendedFormTextFieldCell.swift
//  inVISABLE
//
//  Created by Angelica Bato on 1/7/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import SwiftForms

fileprivate var passwordEntered: String?

extension FormTextFieldCell {
    
}

class ExtendedFormTextFieldCell: FormTextFieldCell {
    public let confirmedText = UILabel()
    override func configure() {
        super.configure()
        confirmedText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmedText)
        contentView.addConstraint(NSLayoutConstraint(item: confirmedText, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: confirmedText, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        textField.addTarget(self, action: #selector(ExtendedFormTextFieldCell.editingEnded(_:)), for: .editingDidEnd)
    }
    
    override func update() {
        super.update()
        confirmedText.isHidden = true
        titleLabel.font = UIFont(name: "Rucksack-Demi", size: 18.0)
        textField.font = UIFont(name: "Rucksack-Book", size: 16.0)
    }
    
    open override func constraintsViews() -> [String : UIView] {
        var views = ["titleLabel" : titleLabel, "textField" : textField, "confirmedText": confirmedText]
        if self.imageView!.image != nil {
            views["imageView"] = imageView
        }
        return views
    }
    
    open override func defaultVisualConstraints() -> [String] {
        if self.imageView!.image != nil {
            if titleLabel.text != nil && (titleLabel.text!).count > 0 {
                return ["H:[imageView]-[titleLabel]-[textField]-[confirmedText]-16-|"]
            } else {
                return ["H:[imageView]-[textField]-[confirmedText]-16-|"]
            }
        } else {
            if titleLabel.text != nil && (titleLabel.text!).count > 0 {
                return ["H:|-16-[titleLabel]-[textField]-[confirmedText]-16-|"]
            } else {
                return ["H:|-16-[textField]-[confirmedText]-16-|"]
            }
        }
    }
    
    @objc func editingEnded(_ sender: UITextField) {
        guard let text = sender.text, let type = rowDescriptor?.type else {
            return
        }
        
        guard text.count > 0 else {
            confirmedText.isHidden = true
            return
        }
        
        let isConfirmed: Bool
        var needsConfirmation: Bool = false
        
        switch type {
        case .name:
            needsConfirmation = true
            isConfirmed = text.count > 0
        case .email:
            needsConfirmation = true
            isConfirmed = text.contains("@") && text.contains(".")
        case .password:
            needsConfirmation = true
            if let _ = passwordEntered {
                isConfirmed = passwordEntered == text
                passwordEntered = nil
            } else {
                isConfirmed = text.count >= 6
                passwordEntered = text
            }
        default:
            isConfirmed = false
        }
        
        if !needsConfirmation {
            return
        }
        
        if isConfirmed {
            confirmedText.text = "✔︎"
            confirmedText.textColor = .green
            confirmedText.isHidden = false
        } else if !isConfirmed {
            confirmedText.text = "✘"
            confirmedText.textColor = .red
            confirmedText.isHidden = false
        }
        
    }
}
