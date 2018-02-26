//
//  PostCell.swift
//  Instagram
//
//  Created by David Tan on 2/26/18.
//  Copyright © 2018 DavidTan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    //@IBOutlet weak var photoView: PFImageView!
    
    var post: Post! {
        didSet {
            let user = post["author"] as? PFUser
            self.usernameLabel.text = user?.username
            
            self.captionLabel.text = post["caption"] as? String
            
            self.postImageView.file = post["media"] as? PFFile
            self.postImageView.loadInBackground()
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
