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
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            if let image = UIImage(named: "inVISABLE!") {
                let view = UIImageView(image: image)
                navigationItem.titleView = view
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MyPageTableViewController.presentNewPostVC))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MyPageTableViewController.logout))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        PostOffice.manager.requestUserPosts(for: INUser.shared.user!.uid) { (success) in
            self.tableView.reloadData()
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
        return PostOffice.manager.userPosts.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellID", for: indexPath) as? ProfileTableViewCell
            if let cell = cell {
                cell.profileCellBio.text = INUser.shared.bio as String
                cell.profileCellName.text = INUser.shared.name as String
                cell.profileCellNumberOfFollowers.text = "\(INUser.shared.numFollowers)"
                cell.profileCellNumberOfFollowing.text = "\(INUser.shared.numFollowing)"
                
                if let image = INUser.shared.image {
                    cell.profileCellImage.image = image
                }
                return cell
            }
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "newPostCellID", for: indexPath)
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCellID", for: indexPath) as? PostTableViewCell
            if let cell = cell {
                cell.postCellName.text = PostOffice.manager.userPosts[indexPath.row - 2].name as String
                cell.postPostLabel.text = PostOffice.manager.userPosts[indexPath.row - 2].post as? String
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            presentNewPostVC()
        }
    }
    
    @objc fileprivate func presentNewPostVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newPostVC")
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
    }
}
