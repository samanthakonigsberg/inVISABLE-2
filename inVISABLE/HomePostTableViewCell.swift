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
    var nav: UINavigationController?
    
    @IBOutlet weak var flagButton: UIButton!
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
        if var image = UIImage(named: "flag") {
            image = image.withRenderingMode(.alwaysTemplate)
            flagButton.imageView?.image = image
        }
        flagButton.tintColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reportWasTapped(_ sender: Any) {
        if let thisPost = post, let currentNav = nav {
            let alert = UIAlertController(title: "Report a post", message: "Are you sure you want to report this post?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                let secondAlert = UIAlertController(title: "Provide a reason to report this post", message: nil, preferredStyle: .alert)
                secondAlert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Reason for reporting"
                })
                let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (alert) in
                    guard let textFields = secondAlert.textFields, let reasonTextField = textFields.first, textFields.count == 1, let text = reasonTextField.text, let currentUser = INUser.shared.user else { return }
                    FirebaseManager.shared.reportPost(currentUser.uid, post: thisPost, reason: text)
                })
                let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                secondAlert.addAction(submitAction)
                secondAlert.addAction(cancel)
                currentNav.dismiss(animated: true, completion: nil)
                currentNav.present(secondAlert, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            currentNav.present(alert, animated: true, completion: nil)
        }
    }
    
}
