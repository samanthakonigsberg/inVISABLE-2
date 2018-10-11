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
    
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
        let _ = Auth.auth().addStateDidChangeListener() { (auth, user) in
            
            if let current = self.currentViewController {
                self.remove(asChildViewController: current)
            }
            
            if let certainUser = user {
                let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
                self.add(asChildViewController: tabBarVC)
                INUser.shared.updateFIRUser(with: certainUser)
                self.currentViewController = tabBarVC
            } else {
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.add(asChildViewController: loginVC)
                self.currentViewController = loginVC
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
        
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

}
