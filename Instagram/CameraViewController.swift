//
//  CameraViewController.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/20/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse
import SnapSliderFilters
import AFNetworking

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SNSliderDataSource {
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var instaImageView: UIImageView!
    let vc = UIImagePickerController()
    var data:[SNFilter]?
    let homeTab = 2
    //var originalPicture: SNFilter?
    var profPic: UIImage?
    
    @IBOutlet var cameraView: UIView!
    
    var slider:SNSlider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vc.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel) {(action) in
    }
    
    func errorMessage(header: String, msg: String) -> UIAlertController {
        let alertController = UIAlertController(title: header, message: msg, preferredStyle: .Alert)
        return alertController
    }
   
    @IBAction func selectPhotoFromLibrary(sender: UIBarButtonItem) {
        //slider.slideShown().image = nil
        //slider.reloadData()
        
        slider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
        
        vc.allowsEditing = false
        vc.sourceType = .PhotoLibrary
        
        vc.modalPresentationStyle = .Popover
        presentViewController(vc,
                              animated: true, completion: nil)
        vc.popoverPresentationController?.barButtonItem = sender

    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            vc.allowsEditing = false
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            vc.cameraCaptureMode = .Photo
            presentViewController(vc, animated: true, completion: nil)
        } else {
            noCamera()
        }
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
        presentViewController(alertVC,
                              animated: true,
                              completion: nil)
    }

    
    func imagePickerController(
        vc: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        instaImageView.contentMode = .ScaleAspectFit
        instaImageView.image = chosenImage
        
        // Create your original filter
        let originalPicture: SNFilter = SNFilter(frame: self.slider.frame, withImage: chosenImage)
        // Generate differents filters by passing in argument the original picture and an array of filter's name
        data = SNFilter.generateFilters(originalPicture, filters: SNFilter.filterNameList)
        
        print("Filter created")
        
        //slider.slideShown().image = originalPicture?.image
        
        self.slider.dataSource = self
        self.slider.userInteractionEnabled = true
        cameraView.addSubview(slider)
        self.slider.reloadData()
        
        print("Slider presented")
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController){
         dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func postPhoto(sender: AnyObject) {
        if instaImageView.image != nil {
            
            //Post.postUserImage(instaImageView.image, withCaption: captionTextField.text, withCompletion: nil)
        if self.profPic != nil {
            Post.postUserImage(slider.slideShown().image!, profPic: self.profPic, withCaption: captionTextField.text, withCompletion: nil)
        }
        else {
            Post.postUserImage(slider.slideShown().image, profPic: slider.slideShown().image, withCaption: captionTextField.text, withCompletion: nil)
        
            //Post.postUserImage(instaImageView.image, withCaption: captionTextField.text, withCompletion: nil)
        }
          captionTextField.text = ""
          instaImageView.image = nil
          slider.slideShown().image = nil
          //slider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
          slider.reloadData()
          slider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
          //performSegueWithIdentifier("postSegue", sender: sender)
          tabBarController?.selectedIndex = homeTab
          print("POSTED")
        }
        else {
            let alert = self.errorMessage("No image selected", msg: "Please try again.")
            alert.addAction(self.cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            print("No image selected")
        }
    }
    
    
    @IBAction func clearPhoto(sender: AnyObject) {
        captionTextField.text = ""
        instaImageView.image = nil
        slider.slideShown().image = nil
        slider.reloadData()
        slider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
    }
    
    // The number of SNFilters that you want in the slider
    func numberOfSlides(slider: SNSlider) -> Int {
        return data!.count
    }
    
    // For a given index, you return the corresponding SNFilter
    func slider(slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        return data![index]
    }
    
    // The starting index of the slider
    func startAtIndex(slider: SNSlider) -> Int {
        return 0
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

