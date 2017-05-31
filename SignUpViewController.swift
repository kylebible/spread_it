//
//  SignUpViewController.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/25/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    var jsonObject : [String : Any]?
    var serverdata = ServerLoginData()
    
    var delegate: LoginDelegate?
    
    //@IBOutlet weak var usernamelabel: UITextField!
    @IBOutlet weak var firstnamelabel: UITextField!
    @IBOutlet weak var lastnamelabel: UITextField!
    @IBOutlet weak var emaillabel: UITextField!
    @IBOutlet weak var passwordlabel: UITextField!
    @IBOutlet weak var confirmpasswordlabel: UITextField!
    
    @IBAction func cancelbutton(_ sender: UIBarButtonItem) {
        delegate?.cancelbuttonpressed(by: self)
    }
    
    func createArray(jsonobj : [String : Any]?){
        jsonObject = jsonobj
        if (jsonObject != nil) {
            var myAlert = UIAlertController(title: "Password Exists", message: "This email  \(emaillabel.text) already exists. Please use signin.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
    }
    
    @IBAction func signupbutton(_ sender: UIButton) {
        //let username = usernamelabel.text
        let firstname = firstnamelabel.text
        let lastname = lastnamelabel.text
        let email = emaillabel.text
        let password = passwordlabel.text
        let confirm = confirmpasswordlabel.text
        
        
        
        
        if firstname! == "" || (firstname?.characters.count)! < 2 {
            firstnamelabel.text = ""
            var myAlert = UIAlertController(title: "First Name", message: "First name must be at least 2 characters.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
        if lastname! == "" || (lastname?.characters.count)! < 2 {
            lastnamelabel.text = ""
            var myAlert = UIAlertController(title: "Last Name", message: "Last name must be at least 2 characters.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
        if isValidEmail(testStr: email!) == false {
            emaillabel.text = ""
            var myAlert = UIAlertController(title: "Email Address", message: "Email Address is invalid. Please try a new one.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
        if password! == "" || (password?.characters.count)! < 7 {
            passwordlabel.text = ""
            var myAlert = UIAlertController(title: "Password", message: "Password must be at least 8 characters.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
        
        let userArr = [firstname, lastname, email, password]
        serverdata.postData(user: userArr as! [String], url: "http://localhost:8000/createUser"){jsonObj in self.createArray(jsonobj: jsonObj)}
        
        if password! != confirm {
            confirmpasswordlabel.text = ""
            var myAlert = UIAlertController(title: "Confrm Password", message: "Password and Confirm Password does not match.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
        else {
            var arr = [String]()
            
            arr.append(firstname!)
            arr.append(lastname!)
            arr.append(email!)
            arr.append(password!)
            delegate?.signupbuttonpressed(by: self, userdata: arr)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
