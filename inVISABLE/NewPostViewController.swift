//
//  NewPostViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 11/4/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    
    @IBAction func postButton(_ sender: UIButton) {
        INUser.shared.add(newPostTextView.text as NSString)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func xOutButton(_ sender: UIButton) {
    }
    
    @IBOutlet weak var newPostTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
