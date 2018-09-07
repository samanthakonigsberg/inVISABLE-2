//
//  ProfileTableViewCell.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 3/27/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit


class ProfileTableViewCell: UITableViewCell {
    var user : INUser?
   
    @IBAction func followButton(_ sender: UIButton) {
        if let u = user, let id = u.id {
          INUser.shared.following = INUser.shared.following.adding(id) as NSArray
            FirebaseManager.shared.updateAllUserInfo()
        }
        sender.setTitle("Unfollow", for: .normal)
        
    }
    
    @IBOutlet weak var followButtonDesign: UIButton!
    
    @IBOutlet weak var profileCellImage: UIImageView!

    @IBOutlet weak var profileCellName: UILabel!

    @IBOutlet weak var profileCellNumberOfFollowing: UILabel!
    
    @IBOutlet weak var profileCellNumberOfFollowers: UILabel!
    
    @IBOutlet weak var profileCellBio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followButtonDesign.layer.cornerRadius = 10
        profileCellImage.roundedImage()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
