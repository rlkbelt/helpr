//
//  LetUsKnowViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import Firebase
class LetUsKnowViewController: UIViewController {
    
    @IBOutlet weak var bStart: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let user = Auth.auth().currentUser
        if user != nil {
            welcomeLabel.text = "Welcome back, " + user!.displayName!.components(separatedBy: " ")[0]
            print(user!.displayName! + " signed in.")
        }else{
            print("No user signed-in")
            
        }
        
        bStart.layer.cornerRadius = 5
        bStart.layer.borderWidth = 2
        bStart.layer.borderColor = UIColor(named: "RoyalPurple")?.cgColor
        
    }


}
