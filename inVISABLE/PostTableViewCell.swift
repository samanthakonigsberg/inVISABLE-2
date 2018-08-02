//
//  PostTableViewCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 3/31/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//


import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postCellImage: UIImageView!
    

    @IBOutlet weak var postCellName: UILabel!
    
    @IBOutlet weak var postPostLabel: UILabel!
    
    override func awakeFromNib() {
        postCellImage.roundedImage()
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
