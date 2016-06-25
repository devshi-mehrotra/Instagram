//
//  PostCell.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/21/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    //@IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    
    
    var user: PFUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.heartImageView.image = UIImage(named: "heart-outline") // or set a placeholder image
    }

}
