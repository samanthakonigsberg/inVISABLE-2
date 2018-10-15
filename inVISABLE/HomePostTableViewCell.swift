//
//  HomePostTableViewCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 4/8/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {
    
    var post: FeedPost?
    
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var homeIconImage: UIImageView!
    @IBOutlet weak var homePostLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        homeIconImage.roundedImage()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let p = post else {
            return
        }
        homeNameLabel.text = p.name as String
        homePostLabel.text = p.post as String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
