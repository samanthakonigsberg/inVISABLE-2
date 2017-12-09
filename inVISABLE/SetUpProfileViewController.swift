//
//  SetUpProfileViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 6/12/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseDatabase


class SetUpProfileViewController: UIViewController {

    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let text = bioTextView.text {
            CurrentUser.shared.bio = text as NSString
        }
        
        if let image = profilePicture.image{
            CurrentUser.shared.image = image
        }
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
    }


}
