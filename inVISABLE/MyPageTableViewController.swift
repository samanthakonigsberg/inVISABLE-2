//
//  MyPageTableViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 3/27/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class MyPageTableViewController: UITableViewController {
    
        override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
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
        return CurrentUser.shared.posts.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellID", for: indexPath) as? ProfileTableViewCell
            if let cell = cell {
                cell.profileCellBio.text = CurrentUser.shared.bio as String
                cell.profileCellName.text = CurrentUser.shared.name as String
                cell.profileCellNumberOfFollowers.text = CurrentUser.shared.followers.stringValue
                cell.profileCellNumberOfFollowing.text = CurrentUser.shared.following.stringValue
                return cell
            }
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "newPostCellID", for: indexPath)
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCellID", for: indexPath) as? PostTableViewCell
            if let cell = cell {
                cell.postCellName.text = CurrentUser.shared.name as String
                cell.postPostLabel.text = CurrentUser.shared.posts[indexPath.row - 2] as? String
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "newPostVC")
            self.present(controller, animated: true, completion: nil)
        }
    }
}
