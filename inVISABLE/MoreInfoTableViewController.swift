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


class MoreInfoTableViewController:FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    struct FormTags {
        static let illnessPickerTag = "illnesses"
        static let interestPickerTag = "interests"
        
    }

    override func viewDidLoad() {
        self.loadForm()
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(MoreInfoTableViewController.submit(_:)))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func submit(_: UIBarButtonItem!) {
        //continue adding to user
        let message = self.form.formValues().description
       
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
        
        
        
        // let locationLabelRow = FormRowDescriptor(tag: FormTags.locationTag, type: .label, title: "Test")
        
        //add sections to form
        form.sections = [section1]
        self.form = form
    }
}
