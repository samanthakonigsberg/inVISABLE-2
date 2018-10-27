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
    @IBOutlet weak var countLabel: UILabel!
    
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
        countLabel.textColor = UIColor.lightGray
        countLabel.text = "140"
        profilePicture.roundedImage()
        
        if let realUserImage = INUser.shared.image {
            profilePicture.image = realUserImage
        } else if INUser.shared.imageRef.length > 0, let data = ImageDownloader.downloader.cache.object(forKey: INUser.shared.imageRef) as? Data {
            profilePicture.image = UIImage(data: data)
        } else {
            profilePicture.image = UIImage(named: "Profile_HiDef")
        }
        
   
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
    
    func textViewDidChange(_ textView: UITextView) {
        let remainingChar = 140 - textView.text.count
        countLabel.text = "\(remainingChar)"
        if remainingChar < 20 {
            countLabel.textColor = .red
        } else {
            countLabel.textColor = .lightGray
        }
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
        return numberOfChars <= 140
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
