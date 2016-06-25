//
//  LikesViewController.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/24/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse

class LikesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var author: PFUser?
    var post: PFObject?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let likeList = post!["likedUsers"] as! [String]
        
        return likeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LikeCell", forIndexPath: indexPath) as! LikeCell
        
        let likeList = post!["likedUsers"] as! [String]
        cell.usernameLabel.text = likeList[indexPath.row]
        
        let likeListFull = post!["likedUsersFull"] as! [PFUser]
        //let user = likeListFull[indexPath.row]
        //let profpic = user["profilePic"] as! PFFile
        //print(profpic.url)
        let tempimage = likeListFull[indexPath.row]["profilePic"]
        tempimage.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)!
                    let profPicView = UIImageView(image: image)
                    profPicView.layer.cornerRadius = profPicView.frame.size.width/2
                    profPicView.clipsToBounds = true
                    //profPicView.image = image
                    //cell.photoView.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.profPicView.image = image
                }
            }
        }
        
        
        //cell.usernameLabel.text = username
        //cell.profPicView.image = profPic
        
        return cell
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
