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
import FirebaseDatabase

class TodayView: UIViewController {
    
    //Allow for the app to interface with Firebase
    let storage = FIRStorage.storage()
    let database = FIRDatabase.database().reference()
    var storageRef : FIRStorageReference!
    var databaseRef : FIRDatabaseReference!
    
    //These variables allow for the user to navigate the JSON file
    var month : String = "November"
    var day : String = "1"
    var whichFact : String = "Nov_1A"
    var whichPhoto: String = "Photo1"
    let pFolder = "Photos"
    let tFolder = "Text"
    let hotBod = "Body"
    let date = "Date"
    
    
    //This variable references which photo should be loaded
    var photo : FIRStorageReference!
    
    //helps to close the menu when it shouldn't be open
    var menuShowing = false
    
    //View outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
     override func viewDidLoad(/*imageView:UIImageView*/)
     {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        menuView.layer.shadowOpacity = 0
        downloadPicture()
        downloadText()
    }
    
    //This function allows for photos to be loaded to the UIImageView "imageView", with month, day, whichFact,pFolder, whichPhoto, and finally photo being used to determine which photo gets loaded
    func downloadPicture()
    {
        self.databaseRef = self.database.child(month).child(day).child(whichFact).child(pFolder).child(whichPhoto).child(whichPhoto)
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.value)
            let m = snapshot.valueInExportFormat() as? String
            print(m)
            self.photo = self.storage.reference(forURL: m!)
            // Placeholder images
            let placeholderImage = UIImage(named: "placeholder.jpg")
            // UIImageView in your ViewController
            // Load the image using SDWebImage
            self.imageView.sd_setImage(with: self.photo, placeholderImage: placeholderImage)
        })
    }
    //This function allows for text to be loaded to the textView "imageView", with month, day, whichFact,tFolder, and hotBod to load the text body, date to load the specific date
    func downloadText()
    {
        self.databaseRef = self.database.child(month).child(day).child(whichFact).child(tFolder).child(hotBod)
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.value)
            let m = snapshot.valueInExportFormat() as? String
            // set the body text view
            self.textView.text = m
        })
        self.databaseRef = self.database.child(month).child(day).child(whichFact).child(tFolder).child(date)
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.value)
            let m = snapshot.valueInExportFormat() as? String
            // set the date label
            self.dateLabel.text = m

        })


    }
 
    //open the side menu
    @IBAction func openSesame(_ sender: Any) {
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
    
    //hide the menu after tapping subfolder
    @IBAction func hideMenuAfterExplore(_ sender: Any) {
        leadingConstraint.constant = -150
        menuShowing = false
    }
}






