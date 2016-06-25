//
//  FeedViewController.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/21/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import MBProgressHUD

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var myposts : [PFObject]?
    var currentPost : PFObject?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var queryLimitCounter = 1
    var mySection : Int?
    
    
    @IBOutlet weak var tableView: UITableView!
    //var posts : [PFObject] = []
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    
        //self.tableView.estimatedRowHeight = 80
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControlAction(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.includeKey("author")
        query.includeKey("_created_at")
        query.includeKey("likedUsersFull")
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.myposts = posts
                //self.posts = tempposts
                // do something with the array of object returned by the call
                //print("YAY")
                for post in posts {
                    print(post["caption"])
                }
            } else {
                print(error?.localizedDescription)
            }
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if let myposts = myposts {
            if myposts.count <= 20 {
                return myposts.count
            }
            else {
                return 20
            }
            
        }
        else {
            return 0
        }*/
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let myposts = myposts {
            /*if myposts.count <= 20 {
                print(myposts.count)
                return myposts.count
            }
            else {
                return 20
            }*/
            return myposts.count
            
        }
        else {
            return 0
        }
        //return 1

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("SECTION " + String(section))
        
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let currentPost = myposts![section]
        let author = currentPost["author"] as! PFUser
        let timestamp = dateFormatter.stringFromDate((currentPost.createdAt)!)//String((currentPost.createdAt)!)// ////
        let username = currentPost["author"].username
        //header.textLabel!.font = UIFont(name: "Futura", size: 10)!
        
        self.mySection = section
        
        let hLabel = UILabel(frame: CGRectMake(0, 0, 400, 40))
        hLabel.font = hLabel.font.fontWithSize(14)
        //hLabel.textColor = kiExtremeOrange
        hLabel.text = "             " + username!! + "   " + timestamp
        hLabel.backgroundColor = UIColor.whiteColor()
        print(hLabel.text)
        header.addSubview(hLabel)
        
        /*let buttonView = UIView()
        let linkToProfile = UIButton(frame: CGRectMake(0, 0, 320, 40))
        //linkToProfile.setTitle("BUTTON", forState: UIControlState.Normal)
        linkToProfile.addTarget(self, action: #selector(FeedViewController.buttonTapped), forControlEvents: .TouchUpInside)
        buttonView.addSubview(linkToProfile)
        header.addSubview(buttonView)*/
        //linkToProfile.setTitle("BUTTON", forState: UIControlState.Normal)
        //header.textLabel!.text = "              " + username!! + "\n       " + timestamp
        
        //header.textLabel!.adjustsFontSizeToFitWidth = true
        //header.textLabel!.textAlignment = NSTextAlignment.Center
        
        if author["profilePic"] != nil {
            print("\(author.username!): PROF PIC NOT NIL")
            let tempimage2 = author["profilePic"] as! PFFile
            
            tempimage2.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = self.resize(UIImage(data:imageData)!, newSize: CGSizeMake(37,37))
    
                        let profPicView = UIImageView(image: image)
                        profPicView.layer.cornerRadius = profPicView.frame.size.width/2
                        profPicView.clipsToBounds = true
                        header.addSubview(profPicView)
                    }
                }
            }
        }
        
        else {
           print("\(author.username!): PROF PIC IS NIL")
           let image = self.resize(UIImage(named: "user-icon")!, newSize: CGSizeMake(37,37))
           let profPicView = UIImageView(image: image)
           profPicView.layer.cornerRadius = profPicView.frame.size.width/2
           profPicView.clipsToBounds = true
           header.addSubview(profPicView)
        
        }

        return header
    }
    
    /*func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let tapGestureRecongizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(tapGestureRecongizer)
    }
    
    func handleGesture(gestureRecongnizer: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("feedToProfileSegue", sender: self)
    }*/
    
    /*func buttonTapped() {
    print("BUTTON TAPPED")
    performSegueWithIdentifier("feedToProfileSeuge", sender: self)
    }*/
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(400)
    }*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //print("CELL FOR ROW AT INDEX PATH")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        
        let post = self.myposts![indexPath.section]//self.myposts![indexPath.row]
        currentPost = post
        let caption = post["caption"] as! String
        //print("\(caption)")
        
        print(caption)
        let likedUsers = post["likedUsers"] as! [String]
        if likedUsers.contains((PFUser.currentUser()?.username)!){
            print("I HAVE LIKED")
            cell.heartImageView.image = UIImage(named:"red-heart")
            print("COLOR SET")
        }

        if post["media"] != nil {
        let tempimage = post["media"] as! PFFile
        print("URL: " + tempimage.url!)
        tempimage.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)!
                    //cell.photoView.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.photoView.image = image
                }
            }
        }
        }
        
        let author = post["author"] as! PFUser
        //author.fetchIfNeededInBackground()
        let likesCount = post["likesCount"] as! Int
        let commentsCount = post["commentsCount"] as! Int
        
        //print(post)
        
        cell.user = author
        
        if caption != "" {
          let user = author.username!
          let string = user + "  " + caption
          
          let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12.0)])
            
           let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(12.0)]
            
            attributedString.addAttributes(boldFontAttribute, range: NSRange(location: 0, length: user.characters.count))
            
            cell.captionLabel.attributedText = attributedString
            
        }
        
        else {
            cell.captionLabel.text = caption
        }
        
        cell.likesCountLabel.text = "Likes: " + String(likesCount)
        cell.commentsCountLabel.text = "Comments: " + String(commentsCount)
    
        return cell
    }
    
    func loadMoreData() {
        
        let query = PFQuery(className: "Post")
        queryLimitCounter = queryLimitCounter + 1
        query.limit = 20 * queryLimitCounter
        query.includeKey("author")
        query.includeKey("likedUsersFull")
        query.orderByDescending("createdAt")
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.myposts = posts
                //self.posts = tempposts
                // do something with the array of object returned by the call
                //print("YAY")
                for post in posts {
                    print(post["caption"])
                }
            } else {
                print(error?.localizedDescription)
            }
            
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            self.tableView.reloadData()
        }
  
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()		
            }
        }
    }
    
    
    @IBAction func clickLike(sender: AnyObject) {
        
        let user = PFUser.currentUser()
        let username = PFUser.currentUser()!.username
         let currentCell = sender.superview!!.superview as! PostCell
        let indexPath = tableView.indexPathForCell(currentCell)
        let currentPost = myposts![indexPath!.section]
        var likedUsers = currentPost["likedUsers"] as! [String]
        var likedUsersFull = currentPost["likedUsersFull"] as! [PFUser]
        
        if !likedUsers.contains(username!) {
          //print(sender.)
          //let currentCell = sender.superview!!.superview as! PostCell
          print(currentCell.captionLabel)
          let currentCount = currentCell.likesCountLabel.text!
          let modCount = Int(currentCount.stringByReplacingOccurrencesOfString("Likes: ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
          //let indexPath = tableView.indexPathForCell(currentCell)
          //let currentPost = myposts![indexPath!.section]
          //print(currentCount)
          currentPost["likesCount"] = modCount! + 1
          //var likedUsers = currentPost["likedUsers"] as! [String]
          likedUsers.append(username!)
          currentPost["likedUsers"] = likedUsers
          
          likedUsersFull.append(user!)
          currentPost["likedUsersFull"] = likedUsersFull
        
          currentPost.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
        }
        currentCell.heartImageView.image = UIImage(named: "red-heart")
        self.tableView.reloadData()
       }
    }
    
    @IBAction func clickUsername(sender: AnyObject) {
        performSegueWithIdentifier("feedToProfileSegue", sender: sender)
    }
    

    @IBAction func checkLikeList(sender: AnyObject) {
        performSegueWithIdentifier("feedToLikeSegue", sender: sender)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "feedToProfileSegue") {
            //let cell = sender?.dequeueReusableCellWithIdentifier("PostCell") //as! UITableViewCell
            //let indexPath = tableView.indexPathForCell(cell!)
             let cell = sender!.superview!!.superview as! PostCell
            print("CAPTION LABEL " + cell.captionLabel.text!)
            //let indexPath = tableView.indexPathForCell(cell)
            //let post = myposts![indexPath!.section]//myposts![indexPath!.section]
            //print(post["caption"])
            //print(self.mySection)
            
            let user = cell.user
            print("USERNAME: "  + user!.username!)
            
            let profileViewController = segue.destinationViewController as! UserPostsViewController
            profileViewController.user = user
        }
        
        else if(segue.identifier == "feedToLikeSegue")
        {
            let cell = sender!.superview!!.superview as! PostCell
            //let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let post = myposts![indexPath!.section]
            
            let likeViewController = segue.destinationViewController as! LikesViewController
            likeViewController.post = post
        }
        
        else {
           let cell = sender as! UITableViewCell
           let indexPath = tableView.indexPathForCell(cell)
          let post = myposts![indexPath!.section]
        
          let detailViewController = segue.destinationViewController as! DetailViewController
          detailViewController.post = post
          tableView.deselectRowAtIndexPath(indexPath!, animated:true)
        }
    }


}


