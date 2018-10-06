//
//  SearchTableViewController.swift
//  inVISABLE
//
//  Created by Angelica Bato on 8/1/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var blockerView: UIView?
    var spinner: UIActivityIndicatorView?
    var results: [INUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Spoonies"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.tintColor = UIColor(named: "ActionNew")
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        let blockerView = UIView(frame: view.frame)
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        blockerView.addSubview(spinner)
        
        blockerView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        blockerView.isHidden = true
        
        self.blockerView = blockerView
        self.spinner = spinner
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let destination: MyPageTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myPage") as? MyPageTableViewController else { return }
        
        destination.user  = results?[indexPath.row]
            navigationController?.pushViewController(destination, animated: true)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let input = searchBar.text else { return }
        
        blockerView?.isHidden = false
        spinner?.startAnimating()
        
        FirebaseManager.shared.findUser(with: input) { (success, error, results) in
            if success {
                self.spinner?.stopAnimating()
                self.blockerView?.isHidden = true
                self.results = results
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        blockerView?.isHidden = false
        spinner?.startAnimating()
        
        FirebaseManager.shared.findUser(with: "") { (success, error, users) in
            if success {
                self.spinner?.stopAnimating()
                self.blockerView?.isHidden = true
                self.results = users
                self.tableView.reloadData()
            }
        }
    }
}
