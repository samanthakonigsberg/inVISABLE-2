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
    /*
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        // ...
        }
 */
    }
    override func viewWillDisappear(_ animated: Bool) {
   //     FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginTapped(_ sender: UIButton) {
        //Test Email and Password: user@gmail.com password
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in

                if let returnedUser = user {
                    //TODO: use UID to reference realtime database to pull down user
                    self.ref?.child("users").child(returnedUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let name = value?["name"] as? NSString ?? ""
                        let followers = value?["followers"] as? NSNumber ?? 0
                        let following = value?["following"] as? NSNumber ?? 0
                        let interests = value?["interests"] as? NSArray ?? []
                        let illnesses = value?["illnesses"] as? NSArray ?? []
                        let location = value?["location"] as? NSString ?? ""
                        
                        CurrentUser.shared = INUser(user: user, image: nil, bio: "", followers: followers, following: following, posts: [], illnesses: illnesses, interests: interests, location: location, name: name)

                        print("")

                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
                        self.present(controller, animated: true, completion: nil)

                        
                        }, withCancel: { (error) in
                            //todo: handle error
                    })
                   // let myUser = User(user: returnedUser, image: nil, bio: "", followers: NSNumber(integerLiteral: 0), following: NSNumber(integerLiteral: 0), posts: [], illnesses: [], interests: [], location: "", name: self.name as NSString)
                    
                    //CurrentUser.shared = myUser
                }
            })}
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
       // let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
        //self.present(controller, animated: true, completion: nil)
    //TODO: build out tab bar controller with table views
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "navVC")
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
