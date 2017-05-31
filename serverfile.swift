//
//  serverfile.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/25/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import Foundation
import UIKit
class ServerLoginData {
    func getData(completion:  @escaping ([Dictionary<String,Any>]) -> ()){
        let url = "http://50.112.71.129/games/"
        
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
    
    
    func newPost(){
        
        // prepare json data
        let param = ["username = Colin","first_name = Colin", "last_name = Jao", "email = colinjao@yahoo.com","password = Password123","confirm_pw = Password123"]
        
        //        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //        if let string = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue) {
        //            print(string)
        //        }
        //
        // create post request
        let url = URL(string: "http://localhost:8000/createUser")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        //        request.httpBody = param.data(using: String.Encoding.utf8)
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
            }
        }
        
        task.resume()
        
    }
    
    
    
    
    func postData(user: [String], url: String, completion: @escaping ([String : Any]?) -> ()){
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        if url == "http://localhost:8000/createUser" {
            //            let parameters = ["username": "colin5","first_name": user[0], "last_name": user[1], "email": user[2], "password": user[3] ] as Dictionary<String, String>
            let url = URL(string: "http://localhost:8000/createUser")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let string1 = "username=\(user[0])"
            let string2 = "&first_name=\(user[0])"
            let string3 = "&last_name=\(user[1])"
            let string4 = "&email=\(user[2])"
            let string5 = "&password=\(user[3])"
            let string6 = "&confirm_pw=\(user[3])"
            let poststring = (string1+string2+string3+string4+string5+string6).data(using:String.Encoding.ascii, allowLossyConversion:false)
            
            
            do {
                request.httpBody = poststring
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                print("response coming in ", data)
//                print(response)
//                print(error)
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 400 {
                        var myAlert = UIAlertController(title: "Email already exists.", message: "Please enter a valid email.", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
                        myAlert.addAction(okAction)
                        //                        self.present(myAlert, animated:true, completion:nil)
                    }
                }
                
                guard error == nil else {
                    
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completion(json)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
        else if url == "http://34.210.30.131/login"{
            print(url)
            
            let url = URL(string: "http://34.210.30.131/login")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            //            let string1 = "username=\(user[0])"
            //            let string2 = "&first_name=\(user[0])"
            //            let string3 = "&last_name=\(user[1])"

            let string4 = "email="+String(user[0])!
            let string5 = "&password="+String(user[1])!
            
            print("email: " + user[0])
            print("password: " + user[1])
            
            if "email=kbible@yahoo.com" == string4 {
                print(true)
            }
            
            
            let newString = string4+string5
            
            
            //            let string6 = "&confirm_pw=\(user[3])"
            let poststring = newString.data(using:String.Encoding.ascii, allowLossyConversion:false)
            
            

            request.httpBody = poststring
                

            print(request)
            print(session)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                print("response coming in: ", data)
                print(response)
                print(error)
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        print("success")
                    }
                }
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]{
                        completion(json)
                    }
                    else {
                        print("no json")
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()        }
        
    }
}
