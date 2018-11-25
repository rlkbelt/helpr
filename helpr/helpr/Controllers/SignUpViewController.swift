//
//  SignUpViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var lFullName: UITextField!
    @IBOutlet weak var lEmail: UITextField!
    @IBOutlet weak var lPassword: UITextField!
    @IBOutlet weak var lConfirmPass: UITextField!
    @IBOutlet weak var bCreateAccount: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bCreateAccount.backgroundColor = UIColor(named: "RoyalPurple")
        bCreateAccount.layer.borderColor = UIColor(named: "RoyalPurple")?.cgColor
        bCreateAccount.layer.cornerRadius = 5
        bCreateAccount.layer.borderWidth = 2
        
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        // 1
        let email = lEmail.text!
        let password = lPassword.text!
        
    
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("Creating user: " + (user?.user.email)!)
            }else{
                print("User empty")
            }
            if error == nil {
                let alert = UIAlertController(title: "Sign-up Successful", message: "You have successfully signed up for helpr!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in self.performSegue(withIdentifier: "goSignIn", sender: self) }))
                self.present(alert, animated: true, completion: nil)
                
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
                    let alert = UIAlertController(title: "Sign-up Failed", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}
