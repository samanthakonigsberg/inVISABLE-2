//
//  TestFormTableViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 12/16/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import SwiftForms
import FirebaseAuth

class TestFormTableViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(TestFormTableViewController.submit(_:)))
    }
    //    }
    func createUser(email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> Void {
        
        
        let values = self.form.formValues()
        if let firstname = values["firstname"] as? NSString , let lastname = values["lastname"] as? NSString {
            
            self.name = NSString(format: "%@ %@" , firstname , lastname)
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let returnedUser = user {
                let myUser = INUser(user: returnedUser, image: nil, bio: "", followers: NSNumber(integerLiteral: 0), following: NSNumber(integerLiteral: 0), posts: [], illnesses: [], interests: [], location: "", name: self.name as NSString)
                
                CurrentUser.shared = myUser
            }
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            completion(user, error)
        }
        
    }
    
    

    @objc func submit(_: UIBarButtonItem!) {
        //continue adding to user
        
        let message = self.form.formValues().description
        
        let alertController = UIAlertController(title: "Form output", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func loadForm(){
        //form descriptor
        let form = FormDescriptor()
        form.title = "Test Form"
        
        //first section
        let section1 = FormSectionDescriptor(headerTitle: "Basics", footerTitle: nil)
        
        let firstNameRow = FormRowDescriptor(tag: FormTags.firstNameTag, type: .name, title: "First Name")
        
        let lastNameRow = FormRowDescriptor(tag: FormTags.lastNameTag, type: .name, title: "Last Name")
        
        let emailRow = FormRowDescriptor(tag: FormTags.emailTag, type: .email, title: "Email")
        
        let passwordRow = FormRowDescriptor(tag: FormTags.passwordTag, type: .password, title: "Password")
        
        let confirmPasswordRow = FormRowDescriptor(tag: FormTags.confirmPasswordTag, type: .password, title: "Confirm Password")
        
        let birthdayRow = FormRowDescriptor(tag: FormTags.birthdayTag, type: .date, title: "Date of Birth")
            birthdayRow.configuration.cell.showsInputToolbar = true
        
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



