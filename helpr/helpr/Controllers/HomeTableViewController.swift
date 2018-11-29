//
//  HomeTableViewController.swift
//  helpr
//
//  Created by Adrian.Parcioaga on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import os.log
import Firebase
import CodableFirebase
class HomeTableViewController: UITableViewController, UISearchResultsUpdating{
    
    //MARK: Properties
    var database = DatabaseHelper()
    static var jobs = [Job]()
    var filteredJobs = [Job]()
    var isPurple = Bool()
    let cellSpacingHeight: CGFloat = 5
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
        
        //loadSampleJobs()
        loadJobs()
        filteredJobs = HomeTableViewController.jobs
        isPurple = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor(named: "RoyalPurple")
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredJobs = HomeTableViewController.jobs.filter { job in
                return job.information.category.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredJobs = HomeTableViewController.jobs
        }
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredJobs.count
        }
        return HomeTableViewController.jobs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HomeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomeTableViewCell else {
            fatalError("The dequeued cell is not an instance of HomeTableVieCell")
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
        cell.jobCategory.text = job.information.category
        cell.jobTitle.text = job.information.title
        cell.jobPic.image = job.pictureData[0]
        cell.jobDistance.text = String(job.information.distance) + " km"
        cell.jobPostedTime.text = job.information.postedTime.timeAgoSinceDate(currentDate: Date(), numericDates: true)

        return cell
    }
    

    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
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
    
    //MARK: Private Methods
    

    
    //Will eventually load jobs from database
    private func loadJobs(){
        database.readJobs(){ jobs in
            HomeTableViewController.jobs = jobs
            self.tableView.reloadData()

        }
    }
    private func loadSampleJobs() {
        guard let job1 = Job(title: "Internet Help", category: "Technology", description: "New Post", pictureURLs: [], tags: [], distance: 5, postalCode: "T2Y 4K7", postedTime: Date(), email: "hilmi@madebyhilmi.com") else {
                fatalError("Unable to instantiate job1")
        }
        guard let job2 = Job(title: "Desperate Cleaning", category: "Cleaning", description: "Trashed place needs super cleaning! Will pay well", pictureURLs: [], tags: [], distance: 7, postalCode: "2Y 4K7", postedTime: Date(), email: "hilmi@madebyhilmi.com") else {
            fatalError("Unable to instantiate job2")
        }
        guard let job3 = Job(title: "Long Story Short Internet Need Help", category: "Technology", description: "My router and modem need a new mesh network for the big data protocol that Google installed in my house last week. I need help.", pictureURLs: [], tags: [], distance: 3, postalCode: "T2Y 4K7", postedTime: Date(), email: "hilmi@madebyhilmi.com") else {
            fatalError("Unable to instantiate job3")
        }
        
        HomeTableViewController.jobs += [job1,job2,job3,job1,job2,job3,job1]
        
        let storage = StorageHelper()
        storage.saveImages(job: job1, imagesArray: [UIImage(named: "comphelp")!], createJob: true)
        storage.saveImages(job: job2, imagesArray: [UIImage(named: "cleaning")!], createJob: true)
        storage.saveImages(job: job3, imagesArray: [UIImage(named: "comphelp")!], createJob: true)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "ShowJobDetails":
            guard let jobViewController = segue.destination as? JobDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedHomeCell = sender as? HomeTableViewCell else {
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
            
        case "CreatePost":
            guard let createPostViewController = segue.destination as? PostAdTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Search-related methods

    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
