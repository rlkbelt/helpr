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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        tfCategory.inputView = pickerView
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
        tvDescription.layer.borderWidth = 1
        
        postPhotos.insert(UIImage(named: "defaultPhoto")!, at: 0)
    }
    
    @IBAction func categoryClick(_ sender: UITextField) {
        pickerView.isHidden = false
        tfCategory.resignFirstResponder()
        return
    }
    @IBAction func categoryDoneEdit(_ sender: UITextField) {
        pickerView.isHidden = true
        sender.resignFirstResponder()
        return
    }

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
        else {
            let alert = UIAlertController(title: "Insufficient Info Provided", message: "Please provide at minimum a category and title for your post to help find suitable Helprs for your needs.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func fieldDoneEditing(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    
    //MARK: CollectionView methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.postImg.image = postPhotos[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexPathForCell = indexPath
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image.
        let itemCount = postPhotos.count
        
        postPhotos[indexPathForCell.row] = selectedImage
        
        var addPhotoExists = false
        for i in 0...itemCount-1 {
            if postPhotos[i] == UIImage(named: "defaultPhoto") ||
                postPhotos[i] == UIImage(named: "CleanDefault") ||
                postPhotos[i] == UIImage(named: "TechDefault") ||
                postPhotos[i] == UIImage(named: "TutorDefault") {
                
                addPhotoExists = true
                break;
            }
        }
        
        if !addPhotoExists && itemCount < 5 {
            postPhotos.insert(UIImage(named: "defaultPhoto")!, at: itemCount)
        }
        self.cvPhotos.reloadData()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Actions
    //MARK: UIPickerView Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
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
        if postPhotos.count == 1 {
            print("One item in postPhotos")
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
