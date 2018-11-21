//
//  LetUsKnowViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit

class LetUsKnowViewController: UIViewController {
    
    @IBOutlet weak var bStart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bStart.layer.cornerRadius = 5
        bStart.layer.borderWidth = 2
        bStart.layer.borderColor = UIColor(named: "RoyalPurple")?.cgColor
        
    }
    
    
}
