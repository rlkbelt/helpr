//
//  MyPostsTableViewCell.swift
//  helpr
//
//  Created by Hilmi Abou-Saleh on 2018-11-04.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit
class MyPostsTableViewCell: UITableViewCell {
    @IBOutlet weak var jobPic: UIImageView!
    @IBOutlet weak var jobCategory: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

