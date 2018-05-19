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
        super.viewDidLoad()
        self.ref = Database.database().reference()

        // Do any additional setup after loading the view.
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


    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        FirebaseManager.shared.login(email: email, password: password) { (success, error) in
            if success {
                //TODO: REMOVE THIS AFTER NAVIGATOR CLASS IS BUILT. DO NOT SHIP.
                let alert = UIAlertController(title: "HURRAY", message: "You are logged in as \(INUser.shared.name)", preferredStyle: .alert)
                let action = UIAlertAction(title: "COOL", style: .default, handler: nil)
                alert.addAction(action)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
//        //Test Email and Password: user@gmail.com password
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "formsID")
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func forgotPasswordTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "forgotPasswordVC")
        self.present(controller, animated: true, completion: nil)
        
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
