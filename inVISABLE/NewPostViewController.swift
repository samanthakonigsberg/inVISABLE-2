//
//  NewPostViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 11/4/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate {
    
    
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
   
        super.viewDidLoad()
        
        if let imageLeft = UIImage(named: "xOUT"){
        
        //create a container view with specific frame
        //insert code below but it in container
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: imageLeft, style: .plain, target: self, action: #selector(NewPostViewController.dismissNewPostVC))
           
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Post", style: .plain, target: self, action: #selector(NewPostViewController.postButton))
    UIBarButtonItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font : UIFont(name: "Rucksack-Medium", size: 16.0) as Any], for: UIControlState.normal)
        
        
        //TODO: finalize colors
        navigationController?.navigationBar.tintColor = UIColor(named: "ActionNew")
        navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
    //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc fileprivate func dismissNewPostVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func postButton() {
        INUser.shared.add(newPostTextView.text as NSString)
        dismiss(animated: true, completion: nil)
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

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 178
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
