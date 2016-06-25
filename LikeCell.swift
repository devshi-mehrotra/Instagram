//
//  LikeCell.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/24/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class LikeCell: UITableViewCell {

    
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
