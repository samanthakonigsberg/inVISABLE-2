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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func followUserTapped(_ sender: Any) {
        if let u = user, let id = u.id {
            INUser.shared.following = INUser.shared.following.adding(id) as NSArray
            FirebaseManager.shared.updateAllUserInfo()
        }
    }
    
}
