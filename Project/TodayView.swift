//
//  ViewController.swift
//  Project
//
//  Created by Eric Larsen on 1/18/17.
//  Copyright © 2017 N00B$. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class TodayView: UIViewController {
    
    //helps to close the menu when it shouldn't be open
    var menuShowing = false
    //View outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
     override func viewDidLoad(/*imageView:UIImageView*/)
     {
        super.viewDidLoad()
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://this-day-in-collecting-history.appspot.com/")
        let reference = storageRef.child("January/1-1 Lincoln.jpg")
        
        // UIImageView in your ViewController
        let imageView: UIImageView = self.imageView
        
        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        // Load the image using SDWebImage
        imageView.sd_setImage(with: reference ,placeholderImage: placeholderImage)
        //imageView.image = UIImage(named: "/Users/ericlarsen/Documents/Project/Project/Menu.png")
        menuView.layer.shadowOpacity = 0
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if (menuShowing){
            leadingConstraint.constant = -150
            UIView.animate(withDuration: 0.3,animations: {self.view.layoutIfNeeded()})
        }
        else{
            leadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3,animations: {self.view.layoutIfNeeded()})
        }
        menuShowing = !menuShowing
    }
    @IBAction func hideMenuAfterExplore(_ sender: Any) {
        leadingConstraint.constant = -150
        menuShowing = false
    }
}






