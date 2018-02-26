//
//  PostCell.swift
//  Instagram
//
//  Created by David Tan on 2/26/18.
//  Copyright © 2018 DavidTan. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var photoView: PFImageView!
    
    var instagramPost: PFObject! {
        didSet {
            self.photoView.file = instagramPost["image"] as? PFFile
            self.photoView.loadInBackground()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
