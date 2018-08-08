//
//  SearchResultTableViewCell.swift
//  inVISABLE
//
//  Created by Angelica Bato on 8/1/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var user: INUser?
    
    @IBOutlet weak var followButtonDesign: UIButton!
    
    override func awakeFromNib() {
        followButtonDesign.layer.cornerRadius = 10
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func followButtonTapped(_ sender: UIButton) {
    
        if let u = user, let id = u.id{
            INUser.shared.following = INUser.shared.following.adding(id) as NSArray
            FirebaseManager.shared.updateAllUserInfo()
            FirebaseManager.shared.updateFollowersFor(userId: id)
            sender.setTitle("Unfollow", for: .normal)
        }
    }
    
}
