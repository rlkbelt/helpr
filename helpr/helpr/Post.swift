//
//  Post.swift
//  helpr
//
//  Created by walter.alvarez on 2018-10-30.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit


class Post {
    
    //MARK: Properties
    
    var category: String
    var title: String
    var description: String
    var tag: String
    var pictures: [UIImage]
    
    //MARK: Initialization
    
    init?(category: String, title: String, description: String, tag: String, pictures: [UIImage]) {
        
        // The title must not be empty
        guard !title.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.category = category
        self.title = title
        self.description = description
        self.tag = tag
        self.pictures = pictures
        
    }
}
