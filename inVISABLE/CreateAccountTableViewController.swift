//
//  CreateAccountTableViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 12/16/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import SwiftForms
import FirebaseAuth

class CreateAccountTableViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var name: NSString = ""
    
    struct FormTags {
        static let firstNameTag = "firstname"
        static let lastNameTag = "lastname"
        static let emailTag = "email"
        static let passwordTag = "password"
        static let confirmPasswordTag = "confirmpassword"
        static let birthdayTag = "dateofbirth"
        static let bioTag = "bio"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //we will load form here
        self.loadForm()
    }
    override func viewDidAppear(_ animated: Bool) {
         if UserDefaults.standard.bool(forKey: "didAgree") != true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "EULAvc")
            self.present(controller, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .plain, target: self, action: #selector(submit(_sender: )))
        UIBarButtonItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font : UIFont(name: "Rucksack-Medium", size: 16.0) as Any], for: UIControlState.normal)
      
        
        //TODO: finalize colors
        navigationController?.navigationBar.tintColor = UIColor(named: "ActionNew")
        navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font : UIFont(name: "Rucksack-Bold", size: 18.0) as Any]
      
    }

    @objc func submit(_sender: UIBarButtonItem!) {
        guard let email = valueForTag(FormTags.emailTag) as? String,
            let password = valueForTag(FormTags.passwordTag) as? String,
            let firstName = valueForTag(FormTags.firstNameTag) as? String,
            let lastName = valueForTag(FormTags.lastNameTag) as? String
        else {
            let alert = UIAlertController(title: "Please complete all required information", message: "It seems you're still missing a few items to set up your account. Please fill out all fields before continuing.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        FirebaseManager.shared.createUser(email: email, password: password) { (success, error) in
            DispatchQueue.main.async {
                guard success else {
                    let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                        //clear values
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                INUser.shared.name = NSString(string: "\(firstName) \(lastName)")
                FirebaseManager.shared.updateAllUserInfo()
                self.performSegue(withIdentifier: "toMoreInfo", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func loadForm(){
        //form descriptor
        let form = FormDescriptor()
        form.title = "Create an account"
        
        //first section
        let section1 = FormSectionDescriptor(headerTitle: " ", footerTitle: nil)
   
        
        let firstNameRow = FormRowDescriptor(tag: FormTags.firstNameTag, type: .name, title: "First Name")
        firstNameRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
        firstNameRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        
        let lastNameRow = FormRowDescriptor(tag: FormTags.lastNameTag, type: .name, title: "Last Name")
        lastNameRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
        lastNameRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        
        let emailRow = FormRowDescriptor(tag: FormTags.emailTag, type: .email, title: "Email")
        emailRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
        emailRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        
        let passwordRow = FormRowDescriptor(tag: FormTags.passwordTag, type: .password, title: "Password")
        passwordRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
        passwordRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
       
        let confirmPasswordRow = FormRowDescriptor(tag: FormTags.confirmPasswordTag, type: .password, title: "Confirm Password")
        confirmPasswordRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
        confirmPasswordRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        
        
        let birthdayRow = FormRowDescriptor(tag: FormTags.birthdayTag, type: .date, title: "Date of Birth")
        birthdayRow.configuration.cell.cellClass = ExtendedFormDateCell.self
        birthdayRow.configuration.cell.showsInputToolbar = true

        //row descriptor of a picker --> change font when selected
        
        section1.rows.append(firstNameRow)
        section1.rows.append(lastNameRow)
        section1.rows.append(emailRow)
        section1.rows.append(passwordRow)
        section1.rows.append(confirmPasswordRow)
        section1.rows.append(birthdayRow)
    
        //add sections to form
        form.sections = [section1]
        self.form = form
    }
}



