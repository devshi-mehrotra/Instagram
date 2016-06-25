//
//  CommentViewController.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/24/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var post: PFObject?
    @IBOutlet weak var commentField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControlAction(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        // Do any additional setup after loading the view.
    }

    
    func refreshControlAction(refreshControl: UIRefreshControl) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let comments = post!["comments"] as! [String]
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let commentUsers = post!["commentUsers"] as! [PFUser]
        let comments = post!["comments"] as! [String]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        
        let user = commentUsers[indexPath.row]
        
        cell.commentLabel.text = comments[indexPath.row]
        cell.username.text = user.username
        
        let tempimage = user["profilePic"]
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
                    cell.profPic.image = image
                }
            }
        }
        
        
        return cell
        
    }
    
    @IBAction func clickSend(sender: AnyObject) {
        if commentField.text != "" {
        
          var commentUsers = post!["commentUsers"] as! [PFUser]
          var comments = post!["comments"] as! [String]
        
          commentUsers.insert(PFUser.currentUser()!, atIndex: 0)
          comments.insert(commentField.text!, atIndex: 0)
        
          post!["commentUsers"] = commentUsers
          post!["comments"] = comments
          post!["commentsCount"] = comments.count
            
          print(comments.count)
        
          post!.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
        }
        commentField.text = ""
        viewDidLoad()
      }
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
