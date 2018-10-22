//
//  PrivacyPolicyViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 10/18/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(named: "ActionNew")
        navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
        
        if let p = parent, p.isBeingPresented {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(PrivacyPolicyViewController.dismissVC))
        }
        
    }
    @objc fileprivate func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
