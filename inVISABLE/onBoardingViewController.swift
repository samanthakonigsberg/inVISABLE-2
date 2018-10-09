//
//  onBoardingViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 10/1/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit

class onBoardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    UIBarButtonItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font : UIFont(name: "Rucksack-Medium", size: 16.0) as Any], for: UIControlState.normal)
        
        navigationController?.navigationBar.tintColor = UIColor(named: "ActionNew")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(onBoardingViewController.dismissAction))
        // Do any additional setup after loading the view.
        
       
    }
    
    @objc private func dismissAction(){
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "didDisplayOnboarding")
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
