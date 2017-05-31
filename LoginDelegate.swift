//
//  LoginDelegate.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/25/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import Foundation
import UIKit

protocol LoginDelegate: class {
    func cancelbuttonpressed(by controller: UIViewController)
    func signupbuttonpressed(by controller: UIViewController, userdata: [String])
}
