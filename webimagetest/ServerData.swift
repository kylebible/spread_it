//
//  ServerData.swift
//  pick up
//
//  Created by KYLE C BIBLE on 5/18/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import Foundation

class ServerData {
    func getData(user: Int, completion:  @escaping ([String: Any]) -> ()){
        let url = "http://34.210.30.131/rest-api/users/\(user)"
        
        // GET request
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            // Handle result
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [String: Any]
                {   print(json)
                    completion(json)
                    //                    self.jsonObject = json
                    //                    print(jsonObject[1]["latitude"]!) // ==> ["MacBook 2015", "iPhone 6s"]
                } else {
                    print("bad json")
                }
            }
            catch let error as NSError {
                
                print(error)
            }
            }.resume()
    }
    
    func getUsers(completion:  @escaping ([Dictionary<String,Any>]) -> ()){
        let url = "http://34.210.30.131/rest-api/users"
        
        // GET request
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            // Handle result
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [Dictionary<String,Any>]
                {   completion(json)
                    //                    self.jsonObject = json
                    //                    print(jsonObject[1]["latitude"]!) // ==> ["MacBook 2015", "iPhone 6s"]
                } else {
                    print("bad json")
                }
            }
            catch let error as NSError {
                
                print(error)
            }
            }.resume()
    }
    
    
    
    func postData(swipe: Int, post_id: Int, user_id: Int){
    //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
    
//    let parameters = ["sport": tupe.2, "message": tupe.3, "latitude": tupe.0, "longitude": tupe.1] as Dictionary<String, String>
    
    //create the url with URL
    let url = URL(string: "http://34.210.30.131/swipePost")!
    
    //create the session object
    let session = URLSession.shared
    
    //now create the URLRequest object using the url object
    var request = URLRequest(url: url)
        
    request.httpMethod = "POST" //set http method as POST
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //            request.setValue("application/json", forHTTPHeaderField: "Accept")
    let string1 = "user_id=\(user_id)"
    let string2 = "&post_id=\(post_id)"
    let string3 = "&like=\(swipe)"
    let poststring = (string1+string2+string3).data(using:String.Encoding.ascii, allowLossyConversion:false)
        
//    request.httpMethod = "POST" //set http method as POST
//    

        request.httpBody = poststring
        
    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
        guard error == nil else {
            return
        }
        
        guard let data = data else {
            return
        }
        
        do {
            //create json object from data
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                //result
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    })
    task.resume()
}
    
    func postNewPostData(title: String, content: String, content_type: String, user_id: Int){
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        //    let parameters = ["sport": tupe.2, "message": tupe.3, "latitude": tupe.0, "longitude": tupe.1] as Dictionary<String, String>
        
        //create the url with URL
        let url = URL(string: "http://34.210.30.131/createPost")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //            request.setValue("application/json", forHTTPHeaderField: "Accept")
        let string1 = "title=\(title)"
        let string2 = "&content=\(content)"
        let string3 = "&content_type=\(content_type)"
        let string4 = "&posted_by=\(user_id)"
        let poststring = (string1+string2+string3+string4).data(using:String.Encoding.ascii, allowLossyConversion:false)
        
        //    request.httpMethod = "POST" //set http method as POST
        //
        
        request.httpBody = poststring
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    //result
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
