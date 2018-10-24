//
//  PostTableViewCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 3/31/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//


import UIKit

class PostTableViewCell: UITableViewCell {
    var post: UserPost?
    
    @IBOutlet weak var postCellImage: UIImageView!
    @IBOutlet weak var postCellName: UILabel!
    @IBOutlet weak var postPostLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        postCellImage.roundedImage()
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let p = post else {
            return
        }
        postCellName.text = p.name as String
        postPostLabel.text = p.post as String
        
        if Calendar.current.isDate(Date(), inSameDayAs: p.date) {
            dateLabel.text = "Today".uppercased()
        } else {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMMM d"
            dateLabel.text = dateformatter.string(from: p.date).uppercased()
        }
        dateLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
