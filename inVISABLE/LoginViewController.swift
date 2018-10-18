//
//  LoginViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 2/4/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var handle : Auth?
    var ref : DatabaseReference?
    
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
  
    
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        forgotPasswordButton.layer.cornerRadius = 10
        super.viewDidLoad()
        self.ref = Database.database().reference()
        passwordTextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
   override func viewWillAppear(_ animated: Bool) {

    }
    override func viewWillDisappear(_ animated: Bool) {
   //     FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        FirebaseManager.shared.login(email: email, password: password) { (success, error) in
            if success {
                let alert = UIAlertController(title: "HURRAY", message: "You are logged in as \(INUser.shared.name)", preferredStyle: .alert)
                let action = UIAlertAction(title: "COOL", style: .default, handler: nil)
                alert.addAction(action)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                ImageDownloader.downloader.hydrateCache()
            }
        }
        
//        //Test Email and Password: user@gmail.com password
        // Second Test Email and Password: user1@gmail.com password1
    }
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "formsID")
        self.present(controller, animated: true, completion: nil)
    }

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBAction func forgotPasswordTapped(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Reset Password", message: "Please enter an email to reset your password", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Email address"
        }
        let sendAction = UIAlertAction(title: "Send", style: .default) { (action) in
            if let textFields = alertController.textFields, let emailTextField = textFields.first, textFields.count == 1, let text = emailTextField.text {
                Auth.auth().sendPasswordReset(withEmail: text, completion: { (error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
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
