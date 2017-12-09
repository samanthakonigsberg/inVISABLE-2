//
//  HomePostTableViewCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 4/8/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var homeNameLabel: UILabel!
    
    @IBOutlet weak var homeIconImage: UIImageView!
    
    @IBOutlet weak var homePostLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
