//
//  CaptureViewController.swift
//  Instagram
//
//  Created by David Tan on 2/25/18.
//  Copyright © 2018 DavidTan. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photo: UIImage!
    var editedPhoto: UIImage!
    //var vc: UIImagePickerController!
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBAction func uploadPhoto(_ sender: Any) {
        getPicture()
    }
    
    @IBAction func postPhoto(_ sender: Any) {
        
        Post.postUserImage(image: editedPhoto, withCaption: captionTextField.text) { (success, error) -> Void in
            if success {
                print("Successful post")
                self.dismiss(animated: true, completion: nil)
                let FeedViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! FeedViewController
                
                self.navigationController?.pushViewController(FeedViewController, animated: true)
            }
            else {
                print("Problem saving post")
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //photoImageView.image = photo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPicture() {
        // Instantiate UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        
        // Check if camera is supported on device
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        //photo = originalImage
        //editedPhoto = editedImage
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = originalImage
            photo = originalImage
        }
        
        editedPhoto = resize(image: photo, newSize: CGSize(width: 100, height:100))
        
        // Dismiss UIImagePickerController to go back to your original view controller
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    // Resize image to store to db
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
