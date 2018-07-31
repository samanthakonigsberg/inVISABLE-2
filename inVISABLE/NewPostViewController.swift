//
//  NewPostViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 11/4/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate {
    
    
    @IBAction func postButton(_ sender: UIButton) {
        INUser.shared.add(newPostTextView.text as NSString)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func xOutButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var xOutButtonOutlet: UIButton!
    
    @IBOutlet weak var newPostTextView: UITextView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        
        if let image = UIImage(named: "FinalLogo") {
            //create a container view with specific frame
            //insert code below but it in container
            let view = UIImageView(image: image)
            view.contentMode = .scaleAspectFit
            navigationItem.titleView = view
        }
        
        newPostTextView.delegate = self
        newPostTextView.text = "What's on your mind?"
        newPostTextView.textColor = UIColor.lightGray
        profilePicture.roundedImage()
    xOutButtonOutlet.layer.cornerRadius = 10
        super.viewDidLoad()
        
    //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if newPostTextView.textColor == UIColor.lightGray {
        newPostTextView.text = nil
        newPostTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if newPostTextView.text.isEmpty {
        newPostTextView.text = "What's on your mind?"
        newPostTextView.textColor = UIColor.lightGray
        }
    }

    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
