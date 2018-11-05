//
//  JobsTableViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import os.log

class JobsTableViewController: UITableViewController {

    //MARK: Properties
    var jobs = [Job]()
    var isPurple = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadSampleJobs()
        isPurple = false
        
        
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "JobsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JobsTableViewCell else {
            fatalError("The dequeued cell is not an instance of JobsTableViewCell")
        }
        
        // fetches the appropriate job for the data source layout
        let job : Job
       
        job = jobs[indexPath.row]
        
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.jobCategory.text = job.category
        cell.jobTitle.text = job.title
        cell.jobPic.image = job.pictures[0]
        cell.jobDistance.text = String(job.distance) + " km"
        
        if (indexPath.row % 2 == 0) {
            if (!isPurple){
                cell.backgroundColor = UIColor(red: 0.819, green: 0.698, blue: 1, alpha: 1)
                cell.jobCategory.textColor = UIColor.white
                cell.jobTitle.textColor = UIColor.white
                cell.jobDistance.textColor = UIColor.white
                isPurple = true
            }
        } else {
            cell.backgroundColor = UIColor.white
            cell.jobCategory.textColor = UIColor(named: "RoyalPurple")
            cell.jobTitle.textColor = UIColor(named: "RoyalPurple")
            cell.jobDistance.textColor = UIColor(named: "RoyalPurple")
            isPurple = false
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    private func loadSampleJobs() {
        guard let job1 = Job(title: "Need my internet set up", category: "Technology", description: "I have recently aquired a new router and do not know how to set up my internet again.\nI am with Shaw, plz hlp.", pictures: [], tags: [], distance: 5, postalCode: "") else {
            fatalError("Unable to instantiate job1")
        }
        guard let job2 = Job(title: "Living room cleaning after party", category: "Cleaning", description: "Horrible, horrible people were at my house last night for a 'small' get-together.\nHouse is trashed, need living room spotless before parents get home.\nWill kill me 100%.", pictures: [], tags: [], distance: 7, postalCode: "") else {
            fatalError("Unable to instantiate job2")
        }
        guard let job3 = Job(title: "Need help with iProgramming course", category: "Tutoring", description: "I am a student at U of C currently in iProgramming, the course is more difficult than I thought.\nSasha is a great man, but I do not want to bother him with my questions.\nNeed tutoring assistance, must know Swift and XCode.", pictures: [], tags: [], distance: 15, postalCode: "") else {
            fatalError("Unable to instantiate job3")
        }
        guard let job4 = Job(title: "Help me sabotage the guy above", category: "Technology", description: "I saw the guy above this post wanted help in iProgramming, I'm also in that class and only one group should emerge victorious.\nHelp me install malware on his computer that destroys his project when it's done.", pictures: [], tags: [], distance: 3, postalCode: "") else {
            fatalError("Unable to instantiate job4")
        }
        
        jobs += [job1,job2,job3,job4,job1,job2,job3,job4,job1]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "showMyJobDetails":
            guard let jobViewController = segue.destination as? JobDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedJobsCell = sender as? JobsTableViewCell else {
                fatalError("Unexpected job sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedJobsCell) else {
                fatalError("The selected meal cell is not being displayed by the table")
            }
            
            let selectedJob: Job
            // fetches the appropriate meal
            selectedJob = jobs[indexPath.row]
            
            
            jobViewController.job = selectedJob
            
        case "ShowMyPostDetails":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    

}
