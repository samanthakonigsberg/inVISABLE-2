//
//  HomeTableViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 4/7/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        UIBarButtonItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font : UIFont(name: "Rucksack-Medium", size: 16.0) as Any], for: UIControlState.normal)
        
        
        //TODO: finalize colors
        navigationController?.navigationBar.tintColor = UIColor(named: "ActionNew")
        navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
        
        //TODO: finalize colors
        tabBarController?.tabBar.tintColor = UIColor(named: "ActionNew")
        tabBarController?.tabBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
        tabBarController?.tabBar.unselectedItemTintColor = .lightGray

        //TODO: Look up and implement postsRef.observe(.childAdded...
        
        if let image = UIImage(named: "FinalLogo") {
            //create a container view with specific frame
            //insert code below but it in container
            let view = UIImageView(image: image)
            view.contentMode = .scaleAspectFit
            navigationItem.titleView = view
        }
        if let imageRight = UIImage(named: "+POST"){
            
            //create a container view with specific frame
            //insert code below but it in container
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: imageRight, style: .plain, target: self, action: #selector(HomeTableViewController.presentNewPostVC))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(HomeTableViewController.logout))
        
        guard let userId = INUser.shared.user?.uid else { return }
        PostOffice.manager.listenToFeedPosts(for: userId) { (newPost) in
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        if UserDefaults.standard.bool(forKey: "didDisplayOnboarding") != true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "navBarOnBoard")
            self.present(controller, animated: true, completion: nil)
        }
        
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostOffice.manager.feedPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as?
            HomePostTableViewCell
        if let cell = cell {
            cell.post = PostOffice.manager.feedPosts[indexPath.row]
            if let data = ImageDownloader.downloader.getImageData(for: PostOffice.manager.feedPosts[indexPath.row].userId as String) {
                let image = UIImage(data: data)
                cell.homeIconImage.image = image
            } else {
                cell.homeIconImage.image = UIImage(named: "Profile_HighDef")
            }
        }

        return cell!
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row ==  PostOffice.manager.feedPosts.count {
            //presentNewPostVC()
        }
    }
    
   
    
}
