//
//  ProfileTableViewCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 3/27/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileCellImage: UIImageView!

    @IBOutlet weak var profileCellName: UILabel!

    @IBOutlet weak var profileCellNumberOfFollowing: UILabel!
    
    @IBOutlet weak var profileCellNumberOfFollowers: UILabel!
    
    @IBOutlet weak var profileCellBio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
