//
//  Job.swift
//  helpr
//
//  Created by adrian.parcioaga on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CodableFirebase

class Job: Codable{
    
    //MARK: Properties
    
    var title: String
    var category: String
    var postDescription: String
    var pictures = [String?]()
    var tags = [String?]()
    var distance: Int
    var postalCode: String
    var postedTime: Date
    var favourite: Bool
    var email: String
    var id: String
    
    
    
    //MARK: Initialization
    init?(title: String, category: String, description: String, pictures: [String?], tags: [String], distance: Int, postalCode: String, postedTime: Date, email: String) {
        self.title = title
        self.category = category
        self.postDescription = description
        self.email = email
        self.pictures = ["test url"]
        if (!tags.isEmpty){
            self.tags = tags
        }else {
            self.tags = ["test tags"]
        }
        
        self.distance = distance
        self.favourite = false
        if (!postalCode.isEmpty){
            self.postalCode = postalCode
        }else{
            self.postalCode = "T1K 3J7"
        }
        self.postedTime = postedTime

        
        //Temp ID until Firebase sets
        id = ""
//        //TODO: Fix pictures (Convert from UIImage into hosted image on Firebase)
//        dict.updateValue(id, forKey: "id")
//        dict.updateValue(title, forKey: "title")
//        dict.updateValue(category, forKey: "category")
//        dict.updateValue(postDescription, forKey: "description")
//        dict.updateValue(["test url"], forKey: "pictures")
//        dict.updateValue(tags, forKey: "tags")
//        dict.updateValue(distance, forKey: "distance")
//        dict.updateValue(postalCode, forKey: "postalCode")
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        dict.updateValue(formatter.string(from: postedTime), forKey: "postedTime")
//        dict.updateValue(favourite, forKey: "favourite")
//        dict.updateValue(email, forKey: "email")
        
    }
    
    
    func setID(id: String){
        self.id = id
        //dict.updateValue(id, forKey: "id")
    }
    
    func getMap() -> MKMapView? {
        return nil
    }
    func getPictures() -> [UIImage?]{
        var UIImagePictures = [UIImage?]()
        if (!pictures.isEmpty) {
            for picture in pictures {
                UIImagePictures.append(UIImage(named: picture!))
            }
        }
        else {
            switch (category) {
            case "Technology":
                let photo = UIImage(named: "comphelp")
                UIImagePictures.append(photo)
                break
            case "Tutoring":
                let photo = UIImage(named: "TutorDefault")
                UIImagePictures.append(photo)
                break
            case "Cleaning":
                let photo = UIImage(named: "cleaning")
                UIImagePictures.append(photo)
                break
            default:
                break
            }
            
        }
        return UIImagePictures
    }

    
}
