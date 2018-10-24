//
//  SetUpProfileViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 6/12/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseDatabase


class SetUpProfileViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var doneDesign: UIButton!
    @IBOutlet weak var libraryDesign: UIButton!
    @IBOutlet weak var cameraDesign: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
   
    @IBOutlet weak var profilePicture: UIImageView!
    let picker = UIImagePickerController()
    
    let defaultText = "Tell us about yourself. This is your place to display illnesses you want your followers to know about."
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextView.textColor == UIColor.lightGray {
            bioTextView.text = nil
            bioTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextView.text.isEmpty {
            bioTextView.text = defaultText
            bioTextView.textColor = UIColor.lightGray
        }
    }
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 178
    }

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
       
        cameraDesign.layer.cornerRadius = 10
        libraryDesign.layer.cornerRadius = 10
        doneDesign.layer.cornerRadius = 10
        profilePicture.roundedImage()
        // Do any additional setup after loading the view.
       
        bioTextView.text = INUser.shared.bio.length > 0 ? INUser.shared.bio as String : defaultText
        bioTextView.delegate = self
        bioTextView.layer.borderWidth = 1.0
        bioTextView.layer.borderColor = UIColor.black.cgColor
        bioTextView.text = defaultText
        bioTextView.textColor = UIColor.lightGray
        profilePicture.roundedImage()
        if let user = INUser.shared.user, let imageData = ImageDownloader.downloader.getCachedImageData(for: user.uid) {
            let image = UIImage(data: imageData)
            INUser.shared.image = image
        }
        profilePicture.image = INUser.shared.image ?? UIImage(named: "Profile_HighDef")
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetUpProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        if let text = bioTextView.text, text != defaultText {
            INUser.shared.bio = text as NSString
            FirebaseManager.shared.updateAllUserInfo()
        }

        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension SetUpProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let scaledAndRotatedImage = rotateCameraImageToProperOrientation(imageSource: chosenImage) else { return }
        
        INUser.shared.image = scaledAndRotatedImage
        FirebaseManager.shared.store(scaledAndRotatedImage)
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.image = scaledAndRotatedImage
        dismiss(animated:true, completion: nil)
    }
}


func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat = 320) -> UIImage? {
    
    guard let imgRef = imageSource.cgImage else {
        return nil
    }
    
    let width = CGFloat(imgRef.width)
    let height = CGFloat(imgRef.height)
    
    var bounds = CGRect(x: 0, y: 0, width: width, height: height)
    
    var scaleRatio : CGFloat = 1
    if (width > maxResolution || height > maxResolution) {
        
        scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
        bounds.size.height = bounds.size.height * scaleRatio
        bounds.size.width = bounds.size.width * scaleRatio
    }
    
    var transform = CGAffineTransform.identity
    let orient = imageSource.imageOrientation
    let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
    
    switch(imageSource.imageOrientation) {
    case .up:
        transform = .identity
    case .upMirrored:
        transform = CGAffineTransform
            .init(translationX: imageSize.width, y: 0)
            .scaledBy(x: -1.0, y: 1.0)
    case .down:
        transform = CGAffineTransform
            .init(translationX: imageSize.width, y: imageSize.height)
            .rotated(by: CGFloat.pi)
    case .downMirrored:
        transform = CGAffineTransform
            .init(translationX: 0, y: imageSize.height)
            .scaledBy(x: 1.0, y: -1.0)
    case .left:
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width;
        bounds.size.width = storedHeight;
        transform = CGAffineTransform
            .init(translationX: 0, y: imageSize.width)
            .rotated(by: 3.0 * CGFloat.pi / 2.0)
    case .leftMirrored:
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width;
        bounds.size.width = storedHeight;
        transform = CGAffineTransform
            .init(translationX: imageSize.height, y: imageSize.width)
            .scaledBy(x: -1.0, y: 1.0)
            .rotated(by: 3.0 * CGFloat.pi / 2.0)
    case .right :
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width;
        bounds.size.width = storedHeight;
        transform = CGAffineTransform
            .init(translationX: imageSize.height, y: 0)
            .rotated(by: CGFloat.pi / 2.0)
    case .rightMirrored:
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width;
        bounds.size.width = storedHeight;
        transform = CGAffineTransform
            .init(scaleX: -1.0, y: 1.0)
            .rotated(by: CGFloat.pi / 2.0)
    }
    
    UIGraphicsBeginImageContext(bounds.size)
    if let context = UIGraphicsGetCurrentContext() {
        if orient == .right || orient == .left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }
        
        context.concatenate(transform)
        context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
    }
    
    let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return imageCopy
}
