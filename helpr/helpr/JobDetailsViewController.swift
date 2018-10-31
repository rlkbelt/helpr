//
//  JobDetailsViewController.swift
//  helpr
//
//  Created by adrian.parcioaga on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit

class JobDetailsViewController: UIViewController {
    
    var job : Job?
    @IBOutlet weak var jobCategory: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var jobPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let job = job {
            jobCategory.text = job.category
            jobTitle.text = job.title
            jobDescription.text = job.description
            jobPic.image = job.pictures[0]
        }
        // Do any additional setup after loading the view.
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
