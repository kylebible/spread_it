//
//  AddPostViewController.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/24/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let choices = ["article","picture","video"]
    var delegate: AddPostDelegate?
    var serverdata = ServerData()
    var selectedRow = String()
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        serverdata.postNewPostData(title: postTitle.text!, content: postURL.text!, content_type: selectedRow, user_id: 1)
        delegate?.goBack(controller: self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.goBack(controller: self)
    }
    @IBOutlet weak var postURL: UITextField!
    @IBOutlet weak var postTitle: UITextField!
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.dataSource = self
        picker.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = choices[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row] as! String
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
