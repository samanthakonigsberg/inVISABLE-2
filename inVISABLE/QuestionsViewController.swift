//
//  QuestionsViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 2/18/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GooglePlaces


//https://developers.google.com/places/ios-api/autocomplete

class QuestionsViewController: UIViewController, GMSAutocompleteViewControllerDelegate{
    
    var ref = Database.database().reference()
    
    @IBOutlet weak var locationSelectedLabel: UILabel!

    @IBOutlet weak var interestsLabel: UILabel!
    
    @IBOutlet weak var illnessesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        illnessesLabel.text = ""
        interestsLabel.text = ""
    // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        illnessesLabel.text = makeArrayString(array: INUser.shared.illnesses as! [String])
        interestsLabel.text = makeArrayString(array: INUser.shared.interests as! [String])

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {

        if let currentUser = INUser.shared.user {
            let userNode = self.ref.child("users").child(currentUser.uid)
            let dictionary: [NSString: Any] = INUser.shared.createUserInfoDictionary()
            userNode.setValue(dictionary)
        }
        
    }

    @IBAction func illnessAddButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "pickerVC") as? PickerViewController{
            controller.array = illnesses
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func interestAddButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "pickerVC") as? PickerViewController{
            controller.array = interests
            present(controller, animated: true, completion: nil)

        }
    }
    
    func makeArrayString(array: [String]) -> String {
        var returnString = ""
        for i in 0..<array.count{
            returnString += "\(i+1). \(array[i])\n"
        }
        return returnString
    }
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
    }
}

extension QuestionsViewController{
        
        // Handle the user's selection.
        @objc(viewController:didAutocompleteWithPlace:) func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            print("Place name: \(place.name)")
            print("Place address: \(place.formattedAddress)")
            print("Place attributions: \(place.attributions)")
            dismiss(animated: true, completion: nil)
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            // TODO: handle the error.
            print("Error: ", error.localizedDescription)
        }
        
        // User canceled the operation.
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            dismiss(animated: true, completion: nil)
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        @objc(viewController:didSelectPrediction:) func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
           
            let a =  prediction.attributedPrimaryText.string
            let b = prediction.attributedSecondaryText?.string
            let fullString = NSMutableString(string: a)
            fullString.append(", ")
            fullString.append(b!)
            locationSelectedLabel.text = fullString as String
            
            //send to singleton here 
            INUser.shared.location =  fullString
            return true
        }
    }

