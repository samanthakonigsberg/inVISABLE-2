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
    //change all INUser.shared to guard statement
    override func viewDidLoad() {
        super.viewDidLoad()
        //figure out experience for if INuser comes back nil
            //pop back to search? error page?
        
        
        //if navigating from tabbar set user? to INUser.shared
        if let image = UIImage(named: "FinalLogo") {
            //create a container view with specific frame
            //insert code below but it in container
            let view = UIImageView(image: image)
            view.contentMode = .scaleAspectFit
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
        guard let realUser = user else {
            return
        }
        PostOffice.manager.requestUserPosts(for: realUser.user!.uid) { (success) in
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
        return PostOffice.manager.userPosts.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellID", for: indexPath) as? ProfileTableViewCell
            if let cell = cell {
                cell.profileCellBio.text = INUser.shared.bio as String
                cell.profileCellName.text = INUser.shared.name as String
                cell.profileCellNumberOfFollowers.text = "\(INUser.shared.numFollowers)"
                cell.profileCellNumberOfFollowing.text = "\(INUser.shared.numFollowing)"
                
                if let image = INUser.shared.image{
                    cell.profileCellImage.image = image
                }
                return cell
            }
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCellID", for: indexPath) as? PostTableViewCell
            if let cell = cell {
                cell.postCellName.text = PostOffice.manager.userPosts[indexPath.row - 1].name as String
                cell.postPostLabel.text = PostOffice.manager.userPosts[indexPath.row - 1].post as? String
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
    }
}
