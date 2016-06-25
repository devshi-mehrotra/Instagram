//
//  UserPostsViewController.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/21/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse

class UserPostsViewController: UIViewController, UICollectionViewDataSource {

    var myposts: [PFObject]?
    
    @IBOutlet weak var profPicImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var numberPostsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let totalColors: Int = 100
    var mycell: PhotoCell?
    var user: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        print("View did load")
        print(PFUser.currentUser())
        self.collectionView.alwaysBounceVertical = true 
        
        let refreshControl = UIRefreshControl()
        refreshControlAction(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "Post")
        //query.limit = 20
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.includeKey("_created_at")
        
        //print("CHECKING USER:" + user!.username!)
        
        if user == nil {
            user = PFUser.currentUser()!
        }
        
        print("CHECKING USER:" + user!.username!)
        
        query.whereKey("author", equalTo: self.user!)
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
            
            self.userLabel.text = String(self.user!.username!)
            
            
            if self.user!["profilePic"] != nil {
                print("PROFILE PIC")
                
                let tempimage = self.user!["profilePic"] as! PFFile
                tempimage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)!
                            //self.profPicImage.contentMode = UIViewContentMode.ScaleAspectFit
                            self.profPicImage.layer.cornerRadius = self.profPicImage.frame.size.width/2
                            self.profPicImage.clipsToBounds = true
                            self.profPicImage.image = image
                        }
                    }
                }
            }
                
            else {
                self.profPicImage.layer.cornerRadius = self.profPicImage.frame.size.width/2
                self.profPicImage.clipsToBounds = true
                self.profPicImage.image = UIImage(named: "user-icon")!
            }
            
            self.collectionView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorForIndexPath(indexPath: NSIndexPath) -> UIColor {
        if indexPath.row >= totalColors {
            return UIColor.blackColor()	// return black if we get an unexpected row index
        }
        
        
        let hueValue: CGFloat = CGFloat(indexPath.row) / CGFloat(totalColors)
        return UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    //extension ViewController: UICollectionViewDataSource {
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if let myposts = myposts {
              numberPostsLabel.text = "Number of Posts: " + String(myposts.count)
              print(myposts.count)
              return myposts.count
            }
            else {
                return 0
            }

        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
            mycell = cell
            /*let cellColor = colorForIndexPath(indexPath)
            cell.backgroundColor = cellColor
            
            if CGColorGetNumberOfComponents(cellColor.CGColor) == 4 {
                let redComponent = CGColorGetComponents(cellColor.CGColor)[0] * 255
                let greenComponent = CGColorGetComponents(cellColor.CGColor)[1] * 255
                let blueComponent = CGColorGetComponents(cellColor.CGColor)[2] * 255
                cell.colorLabel.text = String(format: "%.0f, %.0f, %.0f", redComponent, greenComponent, blueComponent)
            }*/
            
            let post = self.myposts![indexPath.row]
            //let author = post["author"]
            //userLabel.text = author.username
            
            /*if post["profilePic"] != nil {
                print("Not Nil")
                let tempimage = post["profilePic"] as! PFFile
                tempimage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)!
                            cell.photoImageView.contentMode = UIViewContentMode.ScaleAspectFit
                            cell.photoImageView.image = image
                        }
                    }
                }
            }*/
            
            if post["media"] != nil {
            let tempimage = post["media"] as! PFFile
            tempimage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)!
                        cell.photoImageView.contentMode = UIViewContentMode.ScaleAspectFit
                        cell.photoImageView.image = image
                    }
                }
            }
        }
            
            return cell
    }
    
    
    @IBAction func editProfile(sender: AnyObject) {
        performSegueWithIdentifier("editProfSegue", sender: sender)
    }
   
    
    @IBAction func signOut(sender: AnyObject) {
        performSegueWithIdentifier("signOutSegue", sender: sender)
    }
    
    
    /*@IBAction func clickImage(sender: AnyObject) {
        performSegueWithIdentifier("collectionToDetailSegue", sender: sender)
    }*/
    
    //@IBAction func clickImage(sender: AnyObject) {
        //performSegueWithIdentifier("collectionToDetailSegue", sender: PhotoCell())
    //}
    
    //}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //let cell = self.mycell
        if segue.identifier != "editProfSegue" && segue.identifier != "signOutSegue"{
          let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)
          let post = myposts![indexPath!.item]
        
          let detailViewController = segue.destinationViewController as! DetailViewController
          detailViewController.post = post
        }
        //collectionView.deselectRowAtIndexPath(indexPath!, animated:true)
    }

}
