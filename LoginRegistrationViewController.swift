//
//  LoginRegistrationViewController.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/25/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import UIKit
import CoreData

class LoginRegistrationViewController: UIViewController, LoginDelegate {
    
    var jsonObject : [String : Any]?
    var serverdata = ServerLoginData()
    var user = CurrentUser()
    var user_id = Int()
    var all_users = [CurrentUser]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var emaillabel: UITextField!
    
    @IBOutlet weak var passwordlabel: UITextField!
    
    var userArr = [String]()
    
    
    func createArray(jsonobj : [String : Any]?) {
        jsonObject = jsonobj
        if (jsonObject != nil) {
        print("json object: ", jsonObject)
        user_id = jsonObject?["id"] as! Int
        assignUser(id: user_id)
        }
        else {
            let myAlert = UIAlertController(title: "Email/Password Incorrect", message: "Please re-enter email and password.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
            print("here", userArr.count)
        }
    }
    
    @IBAction func loginbutton(_ sender: UIButton) {
        if emaillabel.text == "" {
            var myAlert = UIAlertController(title: "Email Incorrect", message: "Please enter a valid Email.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
        else if passwordlabel.text == ""{
            var myAlert = UIAlertController(title: "Password Incorrect", message: "Please enter respective password.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
        let loginArr = [emaillabel.text, passwordlabel.text]
        serverdata.postData(user: loginArr as! [String], url: "http://34.210.30.131/login"){jsonObj in self.createArray(jsonobj: jsonObj)}
        print("final user id", user_id)
    }
    
    @IBAction func signupbutton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getData()
//        
//        for i in all_users {
//            managedObjectContext.delete(i)
//            saveData()
//        }
//        getData()
//        print(all_users)
//        let user = NSEntityDescription.insertNewObject(forEntityName: "CurrentUser", into: self.managedObjectContext) as! CurrentUser
//        user.logged_in = true
//        user.id = Int64(1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedIn" {
            let navigation = segue.destination as! UITabBarController
            navigation.selectedIndex = 0

        }
        else {
        let navigation = segue.destination as! UINavigationController
        let controller = navigation.topViewController as! SignUpViewController
        controller.delegate = self
        }
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    
    func cancelbuttonpressed(by controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func signupbuttonpressed(by controller: UIViewController, userdata: [String]) {
        //        serverdata.postData(user: userdata as! [String], url: "http://localhost:8000/login"){jsonObj in self.createArray(jsonobj: jsonObj)}
        emaillabel.text = userdata[2]
        passwordlabel.text = userdata[3]
        dismiss(animated: true, completion: nil)
    }
    
    func getData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentUser")
        do {
            let result = try managedObjectContext.fetch(request)
//            print("result: ", result)
            user = (result as! [CurrentUser])[0]
            all_users = result as! [CurrentUser]
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
    
    func assignUser(id: Int) {
        print(user_id)
        let user = NSEntityDescription.insertNewObject(forEntityName: "CurrentUser", into: self.managedObjectContext) as! CurrentUser
        user.logged_in = true
        print("assigning to core data: ", id)
        user.id = Int64(id)
        //        print(user_id)
        self.saveData()
        print("user id after saving data ", user.id)

        
    }

    

    
}

