//
//  ProfileViewController.swift
//  helpr
//
//  Created by walter.alvarez on 2018-11-14.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import os.log
class ProfileViewController: UIViewController {

    @IBOutlet weak var ivProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblJobCount: UILabel!
    @IBOutlet weak var btnSkills: UIButton!
    @IBOutlet weak var tvReviews: UITableView!

    private var storage: StorageHelper = StorageHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfilePicture()
        ivProfilePic.layer.cornerRadius = ivProfilePic.frame.width / 2
        ivProfilePic.layer.borderWidth = 1
        ivProfilePic.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: Action
    @IBAction func imageClicked(_ sender: Any) {
        //Part of the ViewController Extensions
        presentPictureOptions()
    }
    
    //This is magic. Where does this get called?
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        //Post Photo
        storage.updateProfile(picture: selectedImage) { path in
            print(path)
        }
        self.ivProfilePic.image = selectedImage
        
        // Dismiss the picker.
        picker.dismiss(animated: true, completion: nil)
    }
    
    func loadProfilePicture(){
        storage.loadProfilePicture(){image in
            self.ivProfilePic.image = image
        }
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
