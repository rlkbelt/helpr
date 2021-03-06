//
//  PostAdViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-18.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import os.log

class PostAdTableViewController: UITableViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var lCategory: UILabel!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfTags: UITextField!
    @IBOutlet weak var postBtn: UIBarButtonItem!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet var tgrPhotos: UITapGestureRecognizer!
    
    var job: Job?
    var postPhotos = [UIImage]() //allow update of UICollectionViewCells
    var indexPathForCell : IndexPath = [] //variable to allow updating of photos
    var customPhotoAdded = false;
    var addPhotoExists = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvDescription.delegate = self
        postPhotos.insert(UIImage(named: "defaultPhoto")!, at: 0)
        addDoneButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CategoriesTableViewController.selectedCellText != "" {
            lCategory.textColor = UIColor.black
            lCategory.text = CategoriesTableViewController.selectedCellText
            updateCollectionView()
        }
    }
    
    //change UITableView section header text color to RoyalPurple
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            //headerView.contentView.backgroundColor = .white
            headerView.textLabel?.textColor = UIColor.init(named: "RoyalPurple")
        }
    }
    
    //MARK: keyboard accesory view and related methods
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        //define button for previous item and next item as BarButtonItems
        //to update appearance, UIImages in asset folder need to be provided
        let prevButton  = UIBarButtonItem(image: UIImage(named: "backChevron"), style: .plain, target: self, action: #selector(PostAdTableViewController.keyboardPrevButton))
        let nextButton  = UIBarButtonItem(image: UIImage(named: "Chevron"), style: .plain, target: self, action: #selector(PostAdTableViewController.keyboardNextButton))
        prevButton.width = 50.0
        nextButton.width = 50.0
        
        //space between arrow buttons and Done button
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        //done button
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        
        //define the keyboardToolbar to include all defined buttons from above
        keyboardToolbar.items = [prevButton, nextButton, flexBarButton, doneBarButton]
        tfTitle.inputAccessoryView = keyboardToolbar
        tvDescription.inputAccessoryView = keyboardToolbar
        tfTags.inputAccessoryView = keyboardToolbar
    }
    
    @objc func keyboardNextButton(_ sender: Any) {
        //define behaviour for what happens when the next button is pressed while each textfield is active
        if (tfTitle.isFirstResponder) {
            tvDescription.becomeFirstResponder()
        }
        else if (tvDescription.isFirstResponder) {
            tfTags.becomeFirstResponder()
        }
    }
    
    @objc func keyboardPrevButton(_ sender: Any) {
        //define behaviour for what happens when the back button is pressed while each textfield is active
        if (tvDescription.isFirstResponder) {
            tfTitle.becomeFirstResponder()
        }
        else if (tfTags.isFirstResponder) {
            tvDescription.becomeFirstResponder()
        }
    }
    
    //this code allows keyboard to resign when user touches outside of field, unsure if reachable in this class since redesign
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }
    
    //on cancel we must restore every field to startup values since there is no 'Back' button to handle this
    @IBAction func exitPostAd(_ sender: UIBarButtonItem) {
        lCategory.text = "No Category Selected"
        lCategory.textColor = UIColor.lightGray
        tfTitle.placeholder = "No Title Provided"
        tvDescription.textColor = UIColor.lightGray
        tvDescription.text = "Enter your post description here"
        tfTags.placeholder = "#sampleTag"
        postPhotos.removeAll()
        postPhotos.insert(UIImage(named: "defaultPhoto")!, at: 0)
        self.cvPhotos.reloadData()
        customPhotoAdded = false
    }
    
    //when saving we must add the Job object consisting of all the UIView values and call the 'exitPostAd' function to reset fields for next time this view is loaded
    @IBAction func finishAddingPost(_ sender: UIBarButtonItem) {
        let category = lCategory.text
        let title = tfTitle.text ?? "Untitled Post"
        let description = tvDescription.text ?? "No description provided"
        let tags = tfTags.text ?? ""
        let pictures = postPhotos
        
        // Set the job to be passed to HomeTableViewController after the unwind segue.
        if (category?.trimmingCharacters(in: .whitespaces) != "") && (title.trimmingCharacters(in: .whitespaces) != "") {
            job = Job(title: title, category: category!, description: description, pictureURLs: [], tags: [], distance: 10, postalCode: "WH0CR5", postedTime: Date(), email: (UserProfile.loadProfile()?.email)!)
            HomeTableViewController.jobs.append(job!)
            
            let storage = StorageHelper()
            
            storage.saveImages(job: job!, imagesArray: pictures, createJob: true)
            HomeTableViewController.jobs.append(job!)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
            
            exitPostAd(postBtn)
            tabBarController?.selectedIndex = 0
        }
            //title or category were not provided
        else {
            let category = lCategory.text
            let title = tfTitle.text ?? "Untitled Post"
            let description = tvDescription.text ?? "No description provided"
            let tags = tfTags.text ?? ""
            let pictures = postPhotos
            
            // Set the job to be passed to HomeTableViewController after the unwind segue.
            if (category?.trimmingCharacters(in: .whitespaces) != "") && (title.trimmingCharacters(in: .whitespaces) != "") {
                job = Job(title: title, category: category!, description: description, pictureURLs: [], tags: [], distance: 10, postalCode: "WH0CR5", postedTime: Date(), email: (UserProfile.loadProfile()?.email)!)
                
                let storage = StorageHelper()
                
                storage.saveImages(job: job!, imagesArray: pictures, createJob: true)
                HomeTableViewController.jobs.append(job!)
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
                
                exitPostAd(postBtn)
                navigationController?.popViewController(animated: true)
            }
                //title or category were not provided
            else {
                let alert = UIAlertController(title: "Insufficient Info Provided", message: "Please provide at minimum a category and title for your post to help find suitable Helprs for your needs.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //called when the tag textField is tapped aka Editing Begins
    @IBAction func tagEdit(_ sender: UITextField) {
        print("Entered tagEdit")
        tfTags.becomeFirstResponder()
    }
    
    @IBAction func tagExit(_ sender: UITextField) {
        //dummy function to prevent tagFinish from being double-called when tag field is dismissed using return key, while still retaining the EditingDidEnd subcall. Necessary to prevent over-correcting view offset
    }
    
    //called when tag textField is dismissed by either selecting Done on keyboard or anywhere outside field/keyboard is tapped
    @IBAction func tagFinish(_ sender: UITextField) {
        print("Exit tag Edit")
        tfTags.resignFirstResponder()
    }
    
    @IBAction func fieldExit(_ sender: Any) {
        //dummy function to prevent fieldDoneEditing from being double-called when  sender field is dismissed using return key, while still retaining the EditingDidEnd subcall.
        tfTitle.resignFirstResponder()
        tvDescription.becomeFirstResponder()
    }
    
    //called when title textField is dismissed. Originally used for more textFields but class has since evolved. Consider refactoring
    @IBAction func fieldDoneEditing(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
        print("Ending field edit")
        //self.view.endEditing(true)
    }

    //clear 'placeholder' text and change Save button behaviour
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Description field selected for editing")
        if (tvDescription.text == "Enter your post description here") {
            tvDescription.text = ""
        }
        tvDescription.textColor = UIColor.black
    }
 
    //limit character count in Description field
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250   // 250 Limit Value
    }
    
    //if nothing typed, restore 'placeholder' text in light gray color and restore Save button to original functionality
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Description field done editing")
        if (tvDescription.text == "") {
            tvDescription.textColor = UIColor.lightGray
            tvDescription.text = "Enter your post description here"
        }
        postBtn.title = "Post"
    }
    
    //MARK: CollectionView methods
    
    //when the Category label gets updated, we check to see if we can/need to add a category default photo
    func updateCollectionView() {
        if (!customPhotoAdded) {
            print("Only default item in postPhotos")
            switch lCategory.text {
            case "Cleaning":
                postPhotos[0] = UIImage(named: "CleanDefault")!
            case "Technology":
                postPhotos[0] = UIImage(named: "TechDefault")!
            case "Tutoring":
                postPhotos[0] = UIImage(named: "TutorDefault")!
            default:
                print("Unhandled Case")
            }
        }
        checkAddPhoto()
        self.cvPhotos.reloadData()
        return
    }
    
    //ensures that when a photo is added or changed there is another photo that explicitly shows the add photo
    func checkAddPhoto() {
        let lastIndex = postPhotos.count - 1
        if postPhotos[lastIndex] != UIImage(named: "defaultPhoto") {
            postPhotos.insert(UIImage(named: "defaultPhoto")!, at: lastIndex+1)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returns number of objects in photo collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postPhotos.count
    }
    
    //initializes photo collectionview to images stored in postPhotos array, on startup it is just one instance of defaultPhoto
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.postImg.image = postPhotos[indexPath.row]
        return cell
    }
    
    //when a collectionViewCell is selected this function is called to open photo library. Consider editing this function to allow user to take picture at runtime. need to investigate if user discarding photo is handled by system or developer will need to handle that event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexPathForCell = indexPath
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //after photo library opened, if cancel is hit simply close the photo library in animated fashion
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //if user selects photo update collectionViewCell image with selected image. Logic implemented to determine if photo is stock and thus needs to be replaced or if there is an 'add photo' canvas that can be updated
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        if (!customPhotoAdded) {
            postPhotos[0] = selectedImage
        }
        else {
            postPhotos[indexPathForCell.row] = selectedImage
        }
        customPhotoAdded = true
        
        checkAddPhoto()
        self.cvPhotos.reloadData()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

}
