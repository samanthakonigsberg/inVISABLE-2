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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .plain, target: self, action: #selector(submit(_sender: )))
        
       
    }
    
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
    
    

    @objc func submit(_sender: UIBarButtonItem!) {
      self.performSegue(withIdentifier: "toMoreInfo", sender: self)
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
        let section1 = FormSectionDescriptor(headerTitle: "Basics", footerTitle: nil)
        
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



