//
//  JobsTableViewController.swift
//  helpr
//
//  Created by adrian.parcioaga on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import os.log

class JobsTableViewController: UITableViewController, UISearchResultsUpdating {

    //MARK: Properties
    //var jobs = HomeTableViewController.jobs
    var filteredJobs = [Job]()
    var isPurple = Bool()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        filteredJobs = HomeTableViewController.jobs

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
        return HomeTableViewController.jobs.count
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
            job = HomeTableViewController.jobs[indexPath.row]
        }
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.jobCategory.text = job.category
        cell.jobTitle.text = job.title
        cell.jobPic.image = job.getPictures()[0]
        cell.jobDistance.text = String(job.distance) + " km"
        cell.jobPostedTime.text = Utilities.timeAgoSinceDate(job.postedTime, currentDate: Date(), numericDates: true)
        
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
            filteredJobs = HomeTableViewController.jobs.filter { job in
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
