//
//  LaunchViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 9/19/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LaunchViewController: UIViewController, NVActivityIndicatorViewable  {

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating()
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
