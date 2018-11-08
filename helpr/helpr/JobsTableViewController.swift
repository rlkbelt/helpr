//
//  JobsTableViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import os.log

class JobsTableViewController: UITableViewController, UISearchResultsUpdating {

    //MARK: Properties
    var jobs = [Job]()
    var filteredJobs = [Job]()
    var isPurple = Bool()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadSampleJobs()
        filteredJobs = jobs

        isPurple = false
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor(named: "RoyalPurple")
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredJobs.count
        }
        return jobs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "JobsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JobsTableViewCell else {
            fatalError("The dequeued cell is not an instance of JobsTableViewCell")
        }
        
        // fetches the appropriate job for the data source layout
        let job : Job
        if isFiltering() {
            job = filteredJobs[indexPath.row]
        } else {
            job = jobs[indexPath.row]
        }
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
        guard let job1 = Job(title: "Virus!", category: "Technology", description: "My computer is super broken! I need help! I can't connect to the internet.\nI downloaded Brittney Spear's latest album and now I can't turn it off.", pictures: [], tags: [], distance: 2, postalCode: "") else {
            fatalError("Unable to instantiate job1")
        }
        guard let job2 = Job(title: "New Apple iPhone doesn't download cat pictures", category: "Technology", description: "My internet isn't working on my Apple iPhone 5. I bought it brand new yesterday on Kijiji and now I cannot download my cat pictures.\n My mom is going to be so upset when she doesn't get her daily picture!", pictures: [], tags: [], distance: 6, postalCode: "") else {
            fatalError("Unable to instantiate job2")
        }
        guard let job3 = Job(title: "Macbook Pro won't turn on", category: "Technology", description: "Hi I am trying to get my grandsons laptop to work. He gifted it to me and I can't turn it on. Usually I just open the scree and it magically works. Now it doesn't do anything.", pictures: [], tags: [], distance: 4, postalCode: "") else {
            fatalError("Unable to instantiate job3")
        }
       
        
        jobs += [job1,job2,job3]
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
            
            guard let selectedHomeCell = sender as? JobsTableViewCell else {
                fatalError("Unexpected job sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedHomeCell) else {
                fatalError("The selected meal cell is not being displayed by the table")
            }
            
            let selectedJob: Job
            // fetches the appropriate meal
            if isFiltering() {
                selectedJob = filteredJobs[indexPath.row]
            } else {
                selectedJob = HomeTableViewController.jobs[indexPath.row]
            }
            
            jobViewController.job = selectedJob
            
        case "ShowMyPostDetails":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredJobs = jobs.filter { job in
                return job.category.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredJobs = HomeTableViewController.jobs
        }
        tableView.reloadData()
    }
    
    //MARK: - Search-related methods
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    

}
