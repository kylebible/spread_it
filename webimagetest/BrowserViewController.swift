//
//  BrowserViewController.swift
//  webimagetest
//
//  Created by KYLE C BIBLE on 5/24/17.
//  Copyright © 2017 KYLE C BIBLE. All rights reserved.
//

import UIKit
import WebKit
class BrowserViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var delegate : ShowPostDelegate?
    var link : String?
    var indexPath : IndexPath?
    
    @IBOutlet weak var progressView: UIProgressView!
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        //        view.addSubview(webView)
    }
    @IBAction func reload(_ sender: Any) {
        //        progressView.setProgress(0.0, animated: false)
        let myURL = URL(string: link!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.webView.navigationDelegate = self
        print(link!)
        //        if let web = webView{
        //          web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        //        }
        //        else{
        //            print("Addobserver")
        //        }
        //        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        let myURL = URL(string: link!)
        let myRequest = URLRequest(url: myURL!)
        print(myRequest)
        if let web = webView{
            web.load(myRequest)
            //            web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        }else{
            print("WebView not loaded")
        }
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func handleGesture(_ gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right && delegate is FeedViewController {
            // Add this post to be liked by the user to core data ------ (pick random 3 users to show this post)
            // segue back to the main page ----- Done
            // Remove this from the main page and should be shown in the users liked stuff tab
            print("Like")
            //            webView.removeObserver(self, forKeyPath: "estimatedProgress")
            delegate?.actionComplete(controller: self, indexPath: indexPath!, swipe: "like")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left && delegate is FeedViewController {
            // Segue back to the main page ----- Done
            // Remove this from the main page
            print("Dislike")
            //            webView.removeObserver(self, forKeyPath: "estimatedProgress")
            delegate?.actionComplete(controller: self, indexPath: indexPath!, swipe: "dislike")
        }
        
        else if gesture.direction == UISwipeGestureRecognizerDirection.down && delegate is FavoritesViewController {
            print("down")
            delegate?.actionComplete(controller: self, indexPath: indexPath!, swipe: "down")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
}
