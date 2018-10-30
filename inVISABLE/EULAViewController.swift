//
//  EULAViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 10/28/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit

class EULAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(named: "ActionNew")
        navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
        
        if let p = parent, p.isBeingPresented {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(EULAViewController.dismissVC))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(EULAViewController.nextVC))
        }
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func dismissVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginVC")
        self.present(controller, animated: true, completion: nil)
        
    }
    
     @objc fileprivate func nextVC() {
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "didAgree")
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
