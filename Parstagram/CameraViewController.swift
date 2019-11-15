//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Jiale Qiu on 11/11/19.
//  Copyright © 2019 jiale98chinoguay. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

// UIImagePickerControllerDelegate-> "call me back with a function that gives me the image"
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        // create a PF object (Dictionary)
        // setting up database table SCHEMA
        let post = PFObject(className: "Posts")
        
        // pet attributes. E.g. name, weight, owner...
        post["caption"] = commentField.text
        post["author"] = PFUser.current()
        
        // image is the reduced image from before. Save as .png
        // saved in a separate table for my photos
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!) // '!' to unwrap
        
        post["image"] = file // this column will have the url to 'file'
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self // call me back after picking photo
        picker.allowsEditing = true // allow the user to edit photo after picking it
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera // take you to the "camera"
        } else {
            picker.sourceType = .photoLibrary // take you to "photo library"
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    // after picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        // if upload these images directly to Heroku, (at least 10MB) would take long time, and would consume a lot of Heroku's memory
        
        // so import AlamofireImage, resize it, and set to ImageView.
        let size = CGSize(width:300, height:300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        
        // Finally, dismiss (photo library or camera)
        dismiss(animated: true, completion: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
