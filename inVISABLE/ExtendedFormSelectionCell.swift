//
//  ExtendedFormSelectionCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 8/31/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import SwiftForms

class ExtendedFormSelectionCell: FormSelectorCell {
    override func update() {
        super.update()
        titleLabel.font = UIFont(name: "Rucksack-Demi", size: 18.0)
        valueLabel.font = UIFont(name: "Rucksack-Book", size: 18.0)

    }
}
