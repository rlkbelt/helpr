//
//  Job.swift
//  helpr
//
//  Created by adrian.parcioaga on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
import MapKit

class Job {
    
    //MARK: Properties
    
    var title: String
    var category: String
    var description: String
    var pictures = [UIImage?]()
    var tags = [String?]()
    var map: MKMapView? = nil
    var distance: Int
    var postalCode: String
    var postedTime: Date
    var favourite: Bool
    //MARK: Initialization
    
    init?(title: String, category: String, description: String, pictures: [UIImage?], tags: [String], distance: Int, postalCode: String, postedTime: Date) {
        self.title = title
        self.category = category
        self.description = description
        
        if (!pictures.isEmpty) {
            self.pictures = pictures
        }
        else {
            switch (category) {
            case "Technology":
                let photo = UIImage(named: "comphelp")
                self.pictures.append(photo)
                break
            case "Tutoring":
                let photo = UIImage(named: "TutorDefault")
                self.pictures.append(photo)
                break
            case "Cleaning":
                let photo = UIImage(named: "cleaning")
                self.pictures.append(photo)
                break
            default:
                break
            }

        }
        
        if (!tags.isEmpty){
            self.tags = tags
        }
        
        self.distance = distance
        self.favourite = false
        self.postalCode = postalCode
        self.postedTime = postedTime
    }
    
    
}
