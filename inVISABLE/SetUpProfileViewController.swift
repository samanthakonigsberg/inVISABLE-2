//
//  SetUpProfileViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 6/12/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseDatabase


class SetUpProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var bioTextView: UITextView!
   
    @IBOutlet weak var profilePicture: UIImageView!
    let picker = UIImagePickerController()
    


    @IBAction func photoLibrary(_ sender: Any) {
    
    picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
//        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func shootPhoto(_ sender: Any) {
    
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        profilePicture.roundedImage()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
        //Calls this function when the tap is recognized.
        func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }

    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let text = bioTextView.text {
            INUser.shared.bio = text as NSString
        }
        
        if let image = profilePicture.image{
            INUser.shared.image = image
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
        self.present(controller, animated: true, completion: nil)
    }
}

extension SetUpProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
       profilePicture.contentMode = .scaleAspectFit
        profilePicture.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
}

