//
//  MyPageTableViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 3/27/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyPageTableViewController: UITableViewController {

    var user : INUser?
    var image: UIImage?
    
    //change all INUser.shared to guard statement
    override func viewDidLoad() {
        super.viewDidLoad()
        //figure out experience for if INuser comes back nil
            //pop back to search? error page?
        
       
        //if navigating from tabbar set user? to INUser.shared
        if tabBarController?.selectedIndex == 2{
            user = INUser.shared
            user?.id = INUser.shared.user?.uid
        }
    
        if let image = UIImage(named: "FinalLogo") {
            //create a container view with specific frame
            //insert code below but it in container
            let view = UIImageView(image: image)
            view.contentMode = .scaleAspectFit
            navigationItem.titleView = view
        }
        if let imageRight = UIImage(named: "+POST"){
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: imageRight, style: .plain, target: self, action: #selector(MyPageTableViewController.presentNewPostVC))
        }
        
        
        //TODO: finalize colors
        navigationController?.navigationBar.tintColor = UIColor(named: "ActionNew")
        navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
        if let user = user, INUser.shared.name == user.name {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MyPageTableViewController.logout))
            if let imageRight = UIImage(named: "+POST"){
                navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: imageRight, style: .plain, target: self, action: #selector(MyPageTableViewController.presentNewPostVC))
            }
        } else {
            if let imageRight = UIImage(named: "reportUser") {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageRight, style: .plain, target: self, action: #selector(MyPageTableViewController.reportUser))
            }
        }
        UIBarButtonItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font : UIFont(name: "Rucksack-Medium", size: 16.0) as Any], for: UIControlState.normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let realUser = user else {
            return
        }
        
        if let realUserImage = realUser.image {
            image = realUserImage
        } else if realUser.imageRef.length > 0, let data = ImageDownloader.downloader.cache.object(forKey: realUser.imageRef) as? Data {
            image = UIImage(data: data)
        }
        
        if let realID = realUser.id {
            PostOffice.manager.requestUserPosts(for:(realID)) { (success) in
                self.tableView.reloadData()
            }
            tableView.reloadData()
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PostOffice.manager.userPosts.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellID", for: indexPath) as? ProfileTableViewCell
        
            guard let realUser = user else {  return cell!}
            if let cell = cell {
                cell.user = realUser
                cell.profileCellBio.text = realUser.bio as String
                cell.profileCellName.text = realUser.name as String
                cell.profileCellNumberOfFollowers.text = "\(realUser.numFollowers)"
                cell.profileCellNumberOfFollowing.text = "\(realUser.numFollowing)"
                if let user = user, INUser.shared.name == user.name {
                    cell.followButtonDesign.isHidden = true
                }
                
                if let image = self.image {
                    cell.profileCellImage.image = image
                }
                return cell
            }
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCellID", for: indexPath) as? PostTableViewCell
            if let cell = cell {
                cell.post = PostOffice.manager.userPosts[indexPath.row - 1]
                if let image = self.image {
                    cell.postCellImage.image = image
                }
                return cell
            }
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "profileCellID", for: indexPath)
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 270
        } else {
            return 120
        }
    }
    
    @objc fileprivate func presentNewPostVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavBarNewPost")
        self.present(controller, animated: true, completion: nil)
            }
    
    @objc fileprivate func logout() {
        let firebaseAuth = Auth.auth()
        INUser.shared.resetFIRUser()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        PostOffice.manager.feedPosts.removeAll()
        PostOffice.manager.userPosts.removeAll()
    }
    
    @objc fileprivate func reportUser() {
        if let u = user, let id = u.id {
            let alert = UIAlertController(title: "Report a user", message: "Are you sure you want to report this user?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                let secondAlert = UIAlertController(title: "Provide a reason to report user", message: nil, preferredStyle: .alert)
                secondAlert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Reason for reporting"
                })
                let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (alert) in
                    guard let textFields = secondAlert.textFields, let reasonTextField = textFields.first, textFields.count == 1, let text = reasonTextField.text, let currentUser = INUser.shared.user else { return }
                    FirebaseManager.shared.reportUser(id, reporter: currentUser.uid, reason: text)
                })
                let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                secondAlert.addAction(submitAction)
                secondAlert.addAction(cancel)
                self.dismiss(animated: true, completion: nil)
                self.present(secondAlert, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
