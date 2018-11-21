//
//  SignUpViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit

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
    
    
}
