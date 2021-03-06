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

    var posts: [PFObject]?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Auto size row height based on cell autolayout constraints
        //tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 500
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        requestPosts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count  = self.posts?.count
        if let count = count {
            return count
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        //let post = posts![indexPath.row]
        
        cell.post = self.posts![indexPath.row] as? Post
        
        return cell
    }
    
    func requestPosts() {
        //let query = Post.query()
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                print("Successfully fetched posts")
                self.posts = posts
                for p in posts {
                    print (p)
                }
                self.tableView.reloadData()
            } else {
                print("Error when fetching posts")
            }
            
        }
    }
    
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        requestPosts()
        refreshControl.endRefreshing()
    }
    
    
    // Respond to user clicks on cells
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let post = posts![indexPath.row]
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.post = post
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
