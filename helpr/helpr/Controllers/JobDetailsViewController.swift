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
    var bidAmmount : Double = 0
    var bidInput : String = ""

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobDescription: UITextView!
    @IBOutlet weak var jobPic: UIImageView!
    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var jobCategory: UILabel!
    @IBOutlet weak var jobPostedTime: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        bidButton.layer.cornerRadius = 5
        
        jobDescription.layer.cornerRadius = 8;
        if let job = job {
            navigationItem.title = job.category
            jobTitle.text = job.title
            jobDescription.text = job.postDescription
            jobPic.image = job.getPictures()[0]
            jobCategory.text = job.category
            jobPostedTime.text = job.postedTime.timeAgoSinceDate(currentDate: Date(), numericDates: true)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bidOnClick(_ sender: Any) {
        let alert = UIAlertController(title: "Want to bid on this Job?\n Enter bid in dollars below", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter your bid ammount here"
            textField.keyboardType = UIKeyboardType.decimalPad
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let bid = alert.textFields?.first?.text {
                self.bidInput = bid
            }
            if let bidAmmount = Float(self.bidInput) {
                let success = UIAlertController(title: "Bid of $" + String(bidAmmount) + " placed\n\n Please wait for the poster to respond", message: nil, preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "View Bid", style: .default))
                success.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(success, animated: true)
            } else {
                // This statement is printed.
                let fail = UIAlertController(title: "Please Enter a Valid Bid", message: nil, preferredStyle: .alert)
                fail.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(fail, animated: true)
            }
            
        }))
        self.present(alert, animated: true)
        
        // Try to convert to an Int.
        
    }
    
    
    // MARK: - Private Methods

    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
