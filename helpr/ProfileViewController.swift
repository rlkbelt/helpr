//
//  ProfileViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-11-14.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var ivProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblJobCount: UILabel!
    @IBOutlet weak var btnSkills: UIButton!
    @IBOutlet weak var tvReviews: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ivProfilePic.layer.cornerRadius = ivProfilePic.frame.width / 2
        ivProfilePic.layer.borderWidth = 1
        ivProfilePic.layer.borderColor = UIColor.lightGray.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
