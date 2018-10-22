//
//  UpdateNamePasswordTableViewController.swift
//  inVISABLE
//
//  Created by Angelica Bato on 10/21/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import UIKit
import SwiftForms
import FirebaseAuth

class UpdateInfoTableViewController: FormViewController, UINavigationControllerDelegate {
    
    struct FormTags {
        static let noteTag = "note"
        static let firstNameTag = "firstname"
        static let lastNameTag = "lastname"
        static let submitNameTag = "submitname"
        static let passwordTag = "password"
        static let confirmPasswordTag = "confirmpassword"
        static let newPasswordTag = "newpassword"
        static let submitNewPasswordTag = "submitpassword"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //we will load form here
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: finalize colors
        navigationController?.navigationBar.barTintColor = UIColor(white: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font : UIFont(name: "Rucksack-Bold", size: 18.0) as Any]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func loadForm(){
        //form descriptor
        let form = FormDescriptor()
        form.title = "Update your account"
        
        //first section
//        let section1 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)
        
//        let currentName = INUser.shared.name
//        let split = currentName.components(separatedBy: .whitespacesAndNewlines)
//        var first = ""
//        var last = ""
//        if split.count == 2 {
//            first = split[0]
//            last = split[1]
//        }
        
//        let firstNameRow = FormRowDescriptor(tag: FormTags.firstNameTag, type: .name, title: "First Name")
//        firstNameRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
//        firstNameRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject,
//                                                      "textField.placeholder": first as AnyObject]
//
//        let lastNameRow = FormRowDescriptor(tag: FormTags.lastNameTag, type: .name, title: "Last Name")
//        lastNameRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
//        lastNameRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject,
//                                                     "textField.placeholder": last as AnyObject ]
//
//        let submitNameButtonRow = FormRowDescriptor(tag: FormTags.submitNameTag, type: .button, title: "Submit Name")
//        submitNameButtonRow.configuration.cell.cellClass = ExtendedFormButtonCell.self
//        submitNameButtonRow.configuration.button.didSelectClosure = { _ in
//            guard let firstName = self.valueForTag(FormTags.firstNameTag) as? String,
//                let lastName = self.valueForTag(FormTags.lastNameTag) as? String
//                else {
//                    let alert = UIAlertController(title: "Please complete all required information", message: "", preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
//                    return
//            }
//
//            INUser.shared.name = "\(firstName) \(lastName)" as NSString
//            FirebaseManager.shared.updateAllUserInfo()
//        }
//
//        section1.rows.append(firstNameRow)
//        section1.rows.append(lastNameRow)
//        section1.rows.append(submitNameButtonRow)
        
        let section2 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)
        
        let note = FormRowDescriptor(tag: FormTags.noteTag, type: .multilineText, title: "Confirm your current password to change.")
        note.configuration.cell.cellClass = ConfirmCurrentFormTextFieldCell.self
        
        let passwordRow = FormRowDescriptor(tag: FormTags.passwordTag, type: .password, title: "Current Password")
        passwordRow.configuration.cell.cellClass = ConfirmCurrentFormTextFieldCell.self
        
        let checkCurrentPasswordButtonRow = FormRowDescriptor(tag: FormTags.submitNewPasswordTag, type: .button, title: "Confirm Current Password")
        checkCurrentPasswordButtonRow.configuration.cell.cellClass = ExtendedFormButtonCell.self
        checkCurrentPasswordButtonRow.configuration.button.didSelectClosure = { _ in
            guard let user = Auth.auth().currentUser, let email = user.email, let currentPassword = self.valueForTag(FormTags.passwordTag) as? String else { return }
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            user.reauthenticate(with: credential, completion: { (error) in
                if error != nil{
                    self.displayAlert(with: "Incorrect password", message: "The password you entered did not match our records.")
                    return
                } else {
                    let section3 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)
                    
                    let newPasswordRow = FormRowDescriptor(tag: FormTags.newPasswordTag, type: .password, title: "New Password")
                    newPasswordRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
                    newPasswordRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                    
                    let confirmedPasswordRow = FormRowDescriptor(tag: FormTags.confirmPasswordTag, type: .password, title: "Confirm New Password")
                    confirmedPasswordRow.configuration.cell.cellClass = ExtendedFormTextFieldCell.self
                    confirmedPasswordRow.configuration.cell.appearance = ["textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
                    
                    let submitNewPasswordButtonRow = FormRowDescriptor(tag: FormTags.submitNameTag, type: .button, title: "Update Password")
                    submitNewPasswordButtonRow.configuration.cell.cellClass = ExtendedFormButtonCell.self
                    submitNewPasswordButtonRow.configuration.button.didSelectClosure = { _ in
                        guard
                            let confirmedPassword = self.valueForTag(FormTags.confirmPasswordTag) as? String,
                            let newPassword = self.valueForTag(FormTags.newPasswordTag) as? String
                            else {
                                self.displayAlert(with: "Please complete all required information", message: nil)
                                return
                        }
                        
                        guard confirmedPassword == newPassword else {
                            self.displayAlert(with: "Passwords do not match", message: nil)
                            return
                        }
                        
                        guard let currentUser = Auth.auth().currentUser else { return }
                        currentUser.updatePassword(to: newPassword, completion: { (error) in
                            if let _ = error {
                                self.displayAlert(with: "There was a problem updating your password", message: "Something unexpected happened. Please try again.")
                                return
                            } else {
                                self.displayAlert(with: "Success!", message: "We've updated your password.")
                            }
                        })
                    }
                    
                    section3.rows.append(newPasswordRow)
                    section3.rows.append(confirmedPasswordRow)
                    section3.rows.append(submitNewPasswordButtonRow)
                    
                    self.form.sections.append(section3)
                    self.tableView.reloadData()
                }
            })
        }
        
        section2.rows.append(note)
        section2.rows.append(passwordRow)
        section2.rows.append(checkCurrentPasswordButtonRow)
        
        form.sections = [section2]
        self.form = form
    }
    
    private func displayAlert(with title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
