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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let u = user, let id = u.id else { return }
        if INUser.shared.following.contains(id) {
            followButtonDesign.setTitle("Unfollow", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       
        // Configure the view for the selected state
    }
    
   
    @IBAction func followButtonTapped(_ sender: UIButton) {
        guard let u = user, let id = u.id else { return }
        if sender.title(for: .normal) == "Follow" {
            INUser.shared.following = INUser.shared.following.adding(id) as NSArray
            FirebaseManager.shared.updateAllUserInfo()
            FirebaseManager.shared.addUserAsFollowerFor(userId: id)
            ImageDownloader.downloader.hydrateCache()
            sender.setTitle("Unfollow", for: .normal)
        } else {
            let index = INUser.shared.following.index(of: id)
            let mutableArr = NSMutableArray(array: INUser.shared.following)
            mutableArr.removeObject(at: index)
            INUser.shared.following = mutableArr as NSArray
            FirebaseManager.shared.updateAllUserInfo()
            FirebaseManager.shared.removeUserAsFollowerFor(userId: id)
            sender.setTitle("Follow", for: .normal)
        }
    }
   
    
}
