//
//  FeedViewController.swift
//  Instagram
//
//  Created by David Tan on 2/25/18.
//  Copyright © 2018 DavidTan. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var posts = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 500
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        
        cell.usernameLabel.text = "John Smith"
        cell.captionLabel.text = post["caption"] as? String
        
        let imageURL = post["media"]
        cell.postImageView.image = UIImage(named: imageURL as! String)
        
        return cell
    }
    
    func requestPosts() {
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKey("author")
        query?.limit = 20
        
        query?.findObjectsInBackgroundWithBlock { (posts: [Post]?, error: NSError?) -> Void in
            
            if let posts = posts {
                print("Successfully fetched posts")
                self.posts = posts
                for i in posts {
                    print (i)
                }
                self.tableView.reloadData()
            } else {
                print("Error when fetching posts")
            }
            
            }
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
