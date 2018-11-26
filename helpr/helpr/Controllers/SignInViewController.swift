//
//  SignIn.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import Firebase
import os.log

class SignInViewController: UIViewController {
    
    @IBOutlet weak var bLogIn: UIButton!
    @IBOutlet weak var bSignUp: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bLogIn.layer.cornerRadius = 5
        bLogIn.layer.borderWidth = 2
        bLogIn.layer.borderColor = UIColor(named: "RoyalPurple")?.cgColor
        
        bSignUp.layer.cornerRadius = 5
        bSignUp.layer.borderWidth = 2
        bSignUp.layer.borderColor = UIColor(named: "RoyalPurple")?.cgColor
    }
    @IBAction func signInDidPress(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            guard (authResult?.user) != nil else { return }
            if error == nil {
                self.saveUser()
                let alert = UIAlertController(title: "Sign-in successful", message: "You have successfully signed in!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in self.performSegue(withIdentifier: "successfulSignIn", sender: self) }))
                self.present(alert, animated: true, completion: nil)
                //successfulSignIn
                

            }else{
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    var message = ""
                    switch errCode {
                    case .invalidEmail:
                        message = "Email not valid. Please try again with a valid email address."
                    case .emailAlreadyInUse:
                        message = "You have already signed-up for helpr!"
                    default:
                        message = error?.localizedDescription ?? "An error occurred. Please try again."
                    }
                    let alert = UIAlertController(title: "Sign-in failed", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }            }
        }

    }
    
    private func saveUser(){
        let user:User = Auth.auth().currentUser!
        let userProfile = UserProfile(name: user.displayName ?? "invalid display name" , email: user.email ?? "invalid email address")
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userProfile, toFile: UserProfile.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("User profile successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save user profile...", log: OSLog.default, type: .error)
        }
    }
    
    
    
}
