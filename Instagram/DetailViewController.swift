//
//  DetailViewController.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/21/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailPhotoImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let caption = post!["caption"] as! String
        //print("\(caption)")
        
        if post!["media"] != nil {
        let tempimage = post!["media"] as! PFFile
        tempimage.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)!
                    //self.detailPhotoImageView.contentMode = UIViewContentMode.ScaleAspectFit
                    self.detailPhotoImageView.image = image
                }
            }
        }
        }
        
        let author = post!["author"] as! PFUser
        //author.fetchIfNeededInBackground()
        let likesCount = post!["likesCount"] as! Int
        let commentsCount = post!["commentsCount"] as! Int
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let timestamp = dateFormatter.stringFromDate((post!.createdAt)!)
        //let timestamp = post!.createdAt
        //let timestamp = post!["_created_at"] as! String
        print(timestamp)
        print(author)
        
        captionLabel.text = caption
        authorLabel.text = author.username
        likesCountLabel.text = "Likes: " + String(likesCount)
        commentsCountLabel.text = "Comments: " + String(commentsCount)
        timestampLabel.text = String(timestamp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
