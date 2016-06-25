//
//  UserPhotoViewController.swift
//  Pods
//
//  Created by Devshi Mehrotra on 6/22/16.
//
//

import UIKit
import Parse

class UserPhotoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    let picker = UIImagePickerController()
    var profPic: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker,
                                  animated: true,
                                  completion: nil)
        } else {
            noCamera()
        }
    }
    
    
    @IBAction func selectPhotoFromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
                              animated: true, completion: nil)//4
       picker.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func continueButton(sender: AnyObject) {
        if PFUser.currentUser()!["profilePic"] == nil {
            PFUser.currentUser()!["profilePic"] = getPFFileFromImage(UIImage(named: "user-icon")!)
            PFUser.currentUser()?.saveInBackgroundWithBlock(nil)
        }
        
        performSegueWithIdentifier("profToTabSegue", sender: sender)
    }

    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profPic = chosenImage
        PFUser.currentUser()!["profilePic"] = getPFFileFromImage(chosenImage)
        PFUser.currentUser()?.saveInBackgroundWithBlock(nil)
        //Post.postUserImage(nil, profImage: chosenImage, withCaption: "", withCompletion: nil)
        //profileImageView.contentMode = .ScaleAspectFit
        profileImageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //let cell = sender as! UITableViewCell
        //let indexPath = tableView.indexPathForCell(cell)
        //let post = myposts![indexPath!.section]
        
        if self.profPic == nil && PFUser.currentUser()!["profilePicture"] == nil {
            self.profPic = resize(UIImage(named: "user-icon")!, newSize: CGSizeMake(30, 30))
        }
        
        let barViewController = segue.destinationViewController as! UITabBarController
        let nav = barViewController.viewControllers![1] as! UINavigationController
         let destinationViewController = nav.topViewController as! CameraViewController
        print("CHECK")
        destinationViewController.profPic = resize(self.profPic!, newSize: CGSizeMake(30,30))
        //tableView.deselectRowAtIndexPath(indexPath!, animated:true)
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                print("RETURNED")
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }

    

}
