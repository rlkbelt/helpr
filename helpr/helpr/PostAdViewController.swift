//
//  PostAdViewController.swift
//  helpr
//
//  Created by ryan.konynenbelt on 2018-10-18.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit

class PostAdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tfTags: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    
    var post: Post?
    let categories = ["Unselected","Cleaning","Technology","Tutoring"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if (tfCategory.resignFirstResponder() == true) {
            pickerView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func cancelClick(_ sender: UIBarButtonItem) {
        tabBarController?.selectedIndex = 0
        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let category = tfCategory.text ?? ""
        let title = tfTitle.text ?? ""
        let description = tvDescription.text ?? ""
        let tags = tfTags.text ?? ""
        let picture = photoView.image
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        post = Post(category: category, title: title, description: description, tags: tags, picture: picture)
    }
    @IBAction func fieldDoneEditing(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    //MARK: Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (categories[row] != "Unselected") {
        tfCategory.text = categories[row]
        }
        tfCategory.resignFirstResponder()
        pickerView.isHidden = true;
        return
    }
}

