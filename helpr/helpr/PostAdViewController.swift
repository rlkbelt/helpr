//
//  PostAdViewController.swift
//  helpr
//
//  Created by ryan.konynenbelt on 2018-10-18.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import os.log

class PostAdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tfTags: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet var tgrPhotos: UITapGestureRecognizer!
    
    var job: Job?
    let categories = ["Cleaning","Technology","Tutoring"]
    var postPhotos = [UIImage]() //allow update of UICollectionViewCells
    var indexPathForCell : IndexPath = [] //variable to allow updating of phots
    var customPhotoAdded = false;
    var addPhotoExists = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        tfCategory.inputView = pickerView
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
        tvDescription.layer.borderWidth = 1
        
        postPhotos.insert(UIImage(named: "defaultPhoto")!, at: 0)
    }
    
    //unsure what this does but part of solution to scroll view up when textfield is selected but would normally be cut off by keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //function called when need to move view up to prevent textfield from being covered by keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 200)
    }
    
    //function called to move view down once field is no longer being edited and keyboard is dismissed
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 200)
    }
    
    //function that actually animates the movement of view when textview would normally be covered by keyboard
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    //this code allows keyboard to resign when user touches outside of field or hides the pickerView in the case of the category
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if (pickerView.isHidden == false) {
            pickerView.isHidden = true;
        }
    }
    
    //when category textfield is tapped show pickerView with category options
    @IBAction func categoryClick(_ sender: UITextField) {
        pickerView.isHidden = false
        tfCategory.resignFirstResponder()
        return
    }
    
    //when pickerView makes selection this is called to hide pickerView
    @IBAction func categoryDoneEdit(_ sender: UITextField) {
        pickerView.isHidden = true
        sender.resignFirstResponder()
        return
    }
    
    //on cancel we must restore every field to startup values since there is no 'Back' button to handle this
    @IBAction func exitPostAd(_ sender: UIBarButtonItem) {
        tfCategory.text = ""
        tfTitle.text = ""
        tvDescription.text = ""
        tfTags.text = ""
        postPhotos.removeAll()
        postPhotos.insert(UIImage(named: "defaultPhoto")!, at: 0)
        self.cvPhotos.reloadData()
        tabBarController?.selectedIndex = 0
    }
    
    //when saving we must add the Job object consisting of all the UIView values and call the 'exitPostAd' function to reset fields for next time this view is loaded
    @IBAction func finishAddingPost(_ sender: UIBarButtonItem) {
        let category = tfCategory.text
        let title = tfTitle.text ?? "Untitled Post"
        let description = tvDescription.text ?? "No description provided"
        let tags = tfTags.text ?? ""
        let pictures = postPhotos
        
        // Set the job to be passed to HomeTableViewController after the unwind segue.
        if (category?.trimmingCharacters(in: .whitespaces) != "") && (title.trimmingCharacters(in: .whitespaces) != "") {
            job = Job(title: title, category: category!, description: description, pictures: pictures, tags: [], distance: 10, postalCode: "WH0CR5", postedTime: Date())
            HomeTableViewController.jobs.append(job!)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadJobs"), object: nil)
            
            exitPostAd(saveBtn)
            tabBarController?.selectedIndex = 0
        }
            //title or category were not provided
        else {
            let alert = UIAlertController(title: "Insufficient Info Provided", message: "Please provide at minimum a category and title for your post to help find suitable Helprs for your needs.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //called when the tag textField is tapped aka Editing Begins
    @IBAction func tagEdit(_ sender: UITextField) {
        print("Entered tagEdit")
        tfTags.becomeFirstResponder()
        textFieldDidBeginEditing(tfTags)
    }
    
    //called when tag textField is dismissed by either selecting Done on keyboard or anywhere outside field/keyboard is tapped
    @IBAction func tagFinish(_ sender: UITextField) {
        print("Exit tag Edit")
        tfTags.resignFirstResponder()
        textFieldDidEndEditing(tfTags)
    }
    
    //called when title textField is dismissed. Originally used for more textFields but class has since evolved. Consider refactoring
    @IBAction func fieldDoneEditing(_ sender: Any) {
        print("Ending field edit")
        (sender as AnyObject).resignFirstResponder()
    }
    
    //MARK: CollectionView methods
    
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
    
    //when a collectionViewCell is selected this funcion is called to open photo library. Consider editing this function to allow user to take picture at runtime. need to investigate if user discarding photo is handled by system or developer will need to handle that event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexPathForCell = indexPath
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        //imagePickerController.sourceType = .photoLibrary
        
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
        let itemCount = postPhotos.count
        
        postPhotos[indexPathForCell.row] = selectedImage
        customPhotoAdded = true
        
        if !addPhotoExists && itemCount < 5 {
            postPhotos.insert(UIImage(named: "defaultPhoto")!, at: itemCount)
        }
        self.cvPhotos.reloadData()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Actions
    //MARK: UIPickerView Delegate Methods
    
    //returns number of components in pickerView. we currently only have one componenent with category.count rows
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    //title for row of each pickerView is set to value in categories array for that row value
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    //Function changes category textField text to whatever was selected by picker
    //If the only picture in collectionView is defaultPhoto, change to default for that category
    //Add new defaultPhoto to allow addition of more photos (tapRecognizer not working)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        tfCategory.text = categories[row]
        tfCategory.resignFirstResponder()
        pickerView.isHidden = true;
        if (!customPhotoAdded) {
            print("Only default item in postPhotos")
            switch tfCategory.text {
            case "Cleaning":
                postPhotos[0] = UIImage(named: "CleanDefault")!
            case "Technology":
                postPhotos[0] = UIImage(named: "TechDefault")!
            case "Tutoring":
                postPhotos[0] = UIImage(named: "TutorDefault")!
            default:
                print("Unhandled Case")
            }
            postPhotos.insert(UIImage(named: "defaultPhoto")!, at: 1)
            self.cvPhotos.reloadData()
        }
        return
    }
    
    //changes default attributes of pickerView to add text color, background color and more
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            pickerLabel!.backgroundColor = UIColor.lightGray
        }
        let titleData = categories[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26),NSAttributedString.Key.foregroundColor:UIColor(named: "RoyalPurple")!])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        
        return pickerLabel!
    }
}
