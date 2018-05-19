//
//  BaseViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 2/3/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth

class BaseViewController: UIViewController {

    override func viewDidLoad() {
         super.viewDidLoad()
     
            let _ = Auth.auth().addStateDidChangeListener() { (auth, user) in
                if let certainUser = user {
                    INUser.shared.updateFIRUser(with: certainUser)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewcontrollerID: String
                
                if INUser.shared.user != nil {
                    viewcontrollerID = "tabBarVC"
                } else{
                    viewcontrollerID = "loginVC"
                }
                
                let controller = storyboard.instantiateViewController(withIdentifier: viewcontrollerID)
                self.addChildViewController(controller)
                controller.view.frame = self.view.frame
                self.view.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
            }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
