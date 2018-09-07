//
//  ExtendedFormDateCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 8/30/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import SwiftForms

class ExtendedFormDateCell: FormDateCell {
    override func update() {
        super.update()
        titleLabel.font = UIFont(name: "Rucksack-Demi", size: 18.0)
        valueLabel.font = UIFont(name: "Rucksack-Book", size: 16.0)
    }
}
