//
//  Post.swift
//  Instagram
//
//  Created by David Tan on 2/25/18.
//  Copyright © 2018 DavidTan. All rights reserved.
//
import UIKit
import Parse
import ParseUI

class Post: PFObject, PFSubclassing {
    @NSManaged var media : PFFile
    @NSManaged var author: PFUser
    @NSManaged var caption: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Post"
    }
    
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let post = Post()
        
        // Add relevant fields to the object
        post.media = getPFFileFromImage(image: image)! // PFFile column type
        post.author = PFUser.current()! // Pointer column type that points to PFUser
        post.caption = caption!
        post.likesCount = 0
        post.commentsCount = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func lowestReached(unit: String, value: Double) -> Bool {
        let value = Int(round(value));
        switch unit {
        case "sec":
            return value < 60;
        case "min":
            return value < 60;
        case "hr":
            return value < 24;
        case "day":
            return value < 7;
        case "wk":
            return value < 4;
        default: // include "w". cannot reduce weeks
            return true;
        }
    }
    
    class func localizedDate(date: NSDate) -> (unit: String, timeSince: Double) {
        var unit = "/";
        let formatter = DateFormatter();
        formatter.dateFormat = "M";
        let timeSince = Double(formatter.string(from: date as Date))!;
        formatter.dateFormat = "d/yy";
        unit += formatter.string(from: date as Date);
        return (unit, timeSince);
    }
    
    class func timeSince(date: NSDate) -> String {
        var unit = "sec";
        var timeSince = abs(date.timeIntervalSinceNow as Double);
        let reductionComplete = lowestReached(unit: unit, value: timeSince);
        
        while(reductionComplete != true){
            unit = "min";
            timeSince = round(timeSince / 60);
            if lowestReached(unit:unit, value: timeSince) { break; }
            
            unit = "hr";
            timeSince = round(timeSince / 60);
            if lowestReached(unit:unit, value: timeSince) { break; }
            
            unit = "day";
            timeSince = round(timeSince / 24);
            if lowestReached(unit:unit, value: timeSince) { break; }
            
            unit = "wk";
            timeSince = round(timeSince / 7);
            if lowestReached(unit:unit, value: timeSince) { break; }
            
            (unit, timeSince) = localizedDate(date:date);   break;
        }
        
        let value = Int(timeSince);
        return "\(value) \(unit)";
    }
}

