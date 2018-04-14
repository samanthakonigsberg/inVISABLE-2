//
//  MoreInfoTableViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 1/12/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit
import SwiftForms
import FirebaseAuth
import GooglePlaces

class MoreInfoTableViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {
    
    var locationRow: FormRowDescriptor
   
    struct FormTags {
        static let illnessPickerTag = "illnesses"
        static let interestPickerTag = "interests"
        static let locationTag = "location"
    }
    
    required init(coder aDecoder: NSCoder) {
        locationRow = FormRowDescriptor(tag: FormTags.locationTag, type: .button , title: "Select Your Location")
        super.init(coder: aDecoder)
        //we will load form here
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(MoreInfoTableViewController.submit(_:)))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationRow = FormRowDescriptor(tag: FormTags.locationTag, type: .button , title: INUser.shared.location as String)
        //section2.rows removelastvalue
        //section2.rows.append(locationRow)
    }
    
    @objc func submit(_: UIBarButtonItem!) {
        //continue adding to user
        let message = self.form.formValues().description

//        let alertController = UIAlertController(title: "Form output", message: message, preferredStyle: .alert)
//
//        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
//        }
//        alertController.addAction(cancel)
//
//        self.present(alertController, animated: true, completion: nil)
//        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "setUpProfileVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func loadForm(){
        //form descriptor
        let form = FormDescriptor()
        form.title = "About You"
        
        //first section (pickers)
        let section1 = FormSectionDescriptor(headerTitle: "Illnesses and Interests", footerTitle: nil)
        
        let illnessesRow = FormRowDescriptor(tag: FormTags.illnessPickerTag, type: .multipleSelector, title: "Select Your Illnesses")
        illnessesRow.configuration.cell.showsInputToolbar = true
        illnessesRow.configuration.selection.options = illnesses as [AnyObject]
        illnessesRow.configuration.selection.allowsMultipleSelection = true
        illnessesRow.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        
        let interestsRow = FormRowDescriptor(tag: FormTags.interestPickerTag, type: .multipleSelector, title: "Select Your Interests")
        interestsRow.configuration.cell.showsInputToolbar = true
        interestsRow.configuration.selection.options = interests as [AnyObject]
        interestsRow.configuration.selection.allowsMultipleSelection = true
        interestsRow.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        
        section1.rows.append(illnessesRow)
        section1.rows.append(interestsRow)
        
        //section 2 (google places)
        
        let section2 = FormSectionDescriptor(headerTitle: "Location", footerTitle: nil)
        
        locationRow.configuration.button.didSelectClosure = {_ in
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate
            self.navigationController?.pushViewController(autocompleteController, animated: true)
        }
        
      
        section2.rows.append(locationRow)
        // let locationLabelRow = FormRowDescriptor(tag: FormTags.locationTag, type: .label, title: "Test")
        
        //add sections to form
        form.sections = [section1, section2]
        self.form = form
    }
}

extension MoreInfoTableViewController{
    
    // Handle the user's selection.
    @objc(viewController:didAutocompleteWithPlace:) func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        navigationController?.popViewController(animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
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
        //locationLableRow.text = fullString as String
        
        //send to singleton here
        INUser.shared.location =  fullString
        
        //send value back to moreinfo
        
        return true
    }
}

