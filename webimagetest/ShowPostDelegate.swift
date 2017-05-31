//
//  ShowPostDelegate.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/24/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import Foundation
import UIKit

protocol ShowPostDelegate {
    func actionComplete(controller : UIViewController, indexPath : IndexPath, swipe: String)
}
