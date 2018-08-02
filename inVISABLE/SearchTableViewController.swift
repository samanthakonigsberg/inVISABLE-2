//
//  SearchTableViewController.swift
//  inVISABLE
//
//  Created by Angelica Bato on 8/1/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    
    var results: [INUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.findUser(with: "") { (success, error, users) in
            if success {
                self.results = users
                self.tableView.reloadData()
            }
        }
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
        return results?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? SearchResultTableViewCell else {
            
            return UITableViewCell()
        }
        
        if let results = self.results {
            cell.nameLabel.text = results[indexPath.row].name as String
            cell.user = results[indexPath.row]
        }
        
        return cell
    }
}
