//
//  ViewController.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/24/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class FeedViewController: UITableViewController, ShowPostDelegate, AddPostDelegate {
    
    var posts = [[String: Any]]()
    
    var jsonObject : [String: Any]?
    var serverdata = ServerData()
    var all_users = [CurrentUser]()
    var delegate: LoginDelegate?
    var user = CurrentUser()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
//        for i in all_users {
//            managedObjectContext.delete(i)
//            saveData()
//        }
//        getData()
        print("ok")
        print("user: ", user)
        print("useriddddddd: ", user.id)
        // Do any additional setup after loading the view, typically from a nib.
        serverdata.getData(user: Int(user.id)){ jsonObj in self.createArray(jsonobj: jsonObj)}  //grab server data
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture)) //records a left swipe
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        
    }
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addPost", sender: sender)
    }

    
    func handleGesture(_ gesture: UISwipeGestureRecognizer) -> Void {
        
         if gesture.direction == UISwipeGestureRecognizerDirection.left {
            // Segue back to the main page ----- Done
            // Remove this from the main page
            print("Dislike")
            let location = gesture.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: location)
            if let myPath = indexPath {
                posts.remove(at: myPath.row)
                tableView.reloadData()
            }
            else  {
                print("no go")
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPost", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom Cell", for: indexPath) as! CustomCell
        let post = posts[indexPath.row]
        cell.titleLabel.text = post["title"] as? String
        cell.shareCount.text = "\((post["likes"] as! [String]).count) shares"
        if post["content_type"] as! String == "article" {
            cell.thumbnailImage.image = #imageLiteral(resourceName: "news-placeholder")
        }
        else if post["content_type"] as! String == "video" {
            cell.thumbnailImage.image = #imageLiteral(resourceName: "video-placeholder")
        }
        else {
        cell.thumbnailImage.sd_setImage(with: URL(string: post["content"] as! String), placeholderImage: #imageLiteral(resourceName: "placeHolder"))
        }
        
        return cell
}
    
    func createArray(jsonobj : [String : Any]?) {
        jsonObject = jsonobj
        let result = jsonObject!
        posts = result["feed"] as! [[String : Any]]
        DispatchQueue.main.async() {
            self.tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender is IndexPath {
        let nav = segue.destination as! UINavigationController
        let controller = nav.topViewController as! BrowserViewController
        controller.delegate = self
        let indexPath = sender as! IndexPath
        controller.link = posts[indexPath.row]["content"] as? String
        controller.indexPath = indexPath
        }
        else if sender is UIBarButtonItem {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! AddPostViewController
            controller.delegate = self
        }
    }
    
    func actionComplete(controller: UIViewController, indexPath: IndexPath, swipe: String) {
        dismiss(animated: true, completion: nil)
        let post = posts[indexPath.row]
        if swipe == "dislike" {
            posts.remove(at: indexPath.row)
            serverdata.postData(swipe: 0, post_id: post["id"] as! Int , user_id: Int(user.id))
            
        }
        else if swipe == "like"{
            posts.remove(at: indexPath.row)
            serverdata.postData(swipe: 1, post_id: post["id"] as! Int , user_id: Int(user.id))
        }
        serverdata.getData(user: Int(user.id)){ jsonObj in self.createArray(jsonobj: jsonObj)}
    }
    
    func goBack(controller: UIViewController) {
        dismiss(animated: true, completion: nil)
        serverdata.getData(user: Int(user.id)){ jsonObj in self.createArray(jsonobj: jsonObj)}
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "logOut", sender: self)
        managedObjectContext.delete(user)
        saveData()
        user = CurrentUser()
    }
    
    func getData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentUser")
        do {
            let result = try managedObjectContext.fetch(request)
            let resultArr = result as! [CurrentUser]
            user = resultArr[resultArr.count-1]
            all_users = result as! [CurrentUser]
            print(user)
            print(all_users)
        } catch {
            print(error)
        }
    }
    
    func saveData() {
        
        do {
            try managedObjectContext.save()
            print("saving")
        }
        catch {
            print(error)
        }
        
    }
    
    
}

