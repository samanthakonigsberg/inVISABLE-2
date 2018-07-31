//
//  UIImageView.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 7/9/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
       // self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "B_Purple")?.cgColor
    }
    
}
