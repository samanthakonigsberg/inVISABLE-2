//
//  SignUpViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 2/11/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    var email: String?
    var password: String?
    var name: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        name = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func errorMessageHandler(_ code: FIRAuthErrorCode) -> String {
//        switch code {
//        case FIRAuthErrorCode.errorCodeEmailAlreadyInUse:
//            return emailAlreadyInUseMessage
//        case FIRAuthErrorCode.errorCodeInvalidEmail:
//            return invalidEmailMessage
//        case FIRAuthErrorCode.errorCodeWeakPassword:
//            return weakPasswordMessage
//        default:
//            return "Something went wrong. Please try again."
//        }
//    }
    func createUser(email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> Void {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            print(user)
        
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
    
    
    @IBAction func createAccountButtonTapped(_ sender: AnyObject) {
        email = emailTextField.text
        password = passwordTextField.text
        name = firstNameTextField.text! + " " + lastNameTextField.text!

        if let email = email, let password = password {
            createUser(email: email, password: password, completion: { (user, error) in
                //no op
            })
        
        }

    }

    @IBAction func dismissButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
