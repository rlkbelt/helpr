//
//  SignIn.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var bLogIn: UIButton!
    @IBOutlet weak var bSignUp: UIButton!
    
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
    
    
}
