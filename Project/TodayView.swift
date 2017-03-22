//
//  ViewController.swift
//  TDICH
//
//  Created by Eric Larsen on 2/17/17.
//  Copyright © 2017 N00B$. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import FirebaseDatabase
import ImageSlideshow
import ARNTransitionAnimator



//This variable references which photo should be loaded
//Allow for the app to interface with Firebase
let storage = FIRStorage.storage()
let database = FIRDatabase.database().reference()
var storageRef : FIRStorageReference!
var databaseRef : FIRDatabaseReference!

var photoCount : UInt = 0
var dateCount : UInt = 0
var photoArray : [String] = []
var dateArray : [String] = []
var URLArray : [String] = []

//These variables allow for the user to navigate the JSON file
var month = "Dec"
var day = "5"
var whichFact = "Dec_5A"
var whichPhoto = "Photo1"
let photoOne = "Photo1"
var dayFactNumber : UInt = 0
let pFolder = "Photos"
let tFolder = "Text"
let hotBod = "Body"
let date = "Date"
var groupNames = [FIRDataSnapshot]()
var menuShowing = false
var dateText : String?

class TodayView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    //View outlets
    @IBOutlet weak var imageViewBlur: UIImageView!
    @IBOutlet weak var dateLabel: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var sideMenuWidth: NSLayoutConstraint!
    
    //Runs on startup
    override func viewDidLoad()
    {
        getDate()
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        loadAll(completionHandler: { (data:[String]?) -> Void in
            if let photoURLArray = data
            {
                URLArray = photoURLArray
                let arr = photoURLArray.map {SDWebImageSource(urlString: $0 )!}
                print(arr)
                let toImg = Foundation.URL(string: URLArray[0])
                self.imageViewBlur.sd_setImage(with: toImg)
                self.slideshow.setImageInputs(arr)
            }
        })
        
        self.slideshow.backgroundColor = UIColor.clear
        self.slideshow.slideshowInterval = 15.0
        self.slideshow.pageControlPosition = PageControlPosition.underScrollView
        self.slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        self.slideshow.currentPageChanged = { page in
            let toImage = Foundation.URL(string: URLArray[page])
            UIView.transition(with: self.imageViewBlur,
                              duration:1,
                              options: .transitionCrossDissolve,
                              animations: { self.imageViewBlur.sd_setImage(with: toImage) },
                              completion: nil)
            
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TodayView.didTap))
        self.slideshow.addGestureRecognizer(recognizer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    //decides how many items are in the table for selecting facts
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dateArray.count)
        return dateArray.count
    }
    
    func getDate()
    {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day],from: date)
        let m = components.month
        if m==1
        {
            month="Jan"
        }
        else if m==2
        {
            month="Feb"
        }
        else if m==3
        {
            month="Mar"
        }
        else if m==4
        {
            month="Apr"
        }
        else if m==5
        {
            month="May"
        }
        else if m==6
        {
            month="Jun"
        }
        else if m==7
        {
            month="Jul"
        }
        else if m==8
        {
            month="Aug"
        }
        else if m==9
        {
            month="Sep"
        }
        else if m==10
        {
            month="Oct"
        }
        else if m==11
        {
            month="Nov"
        }
        else if m==12
        {
            month="Dec"
        }
        var test = components.day!
        var str : String = "\(test)"
        day=str
        whichFact=month+"_"+day+"A"
        print(whichFact)
    }
    
    //fills the labels in the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dateArray[indexPath.item]
        cell.textLabel?.textColor = UIColor.white
        let backimage = #imageLiteral(resourceName: "Slice 1.png")
        let picView = UIImageView(image: backimage)
        let layer = CALayer()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        picView.layer.addSublayer(layer)
        tableView.backgroundView = picView
        tableView.layer.addSublayer(layer)
        print(dateArray[indexPath.item])
        return cell
    }
    
    //changes the imageviews, text,  etc. when the date fact is changed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        whichFact = dateArray[indexPath.item]
        print(whichFact)
        loadAll(completionHandler: { (data:[String]?) -> Void in
            if let photoURLArray = data
            {
                URLArray = photoURLArray
                let arr = photoURLArray.map {SDWebImageSource(urlString: $0 )!}
                print(arr)
                let toImg = Foundation.URL(string: URLArray[0])
                self.imageViewBlur.sd_setImage(with: toImg)
                self.slideshow.setImageInputs(arr)
                self.slideshow.setCurrentPage(1, animated: true)
            }
        })
        tableHeight.constant = 0
        UIView.animate(withDuration: 0.3,animations: {self.view.layoutIfNeeded()})
        menuShowing = !menuShowing

    }
    
    //This has to do with ImageSlideshow, allowing the photo view to be presented fullscreen
    func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    //Allows the user to share, pretty cool
    @IBAction func shareButton(_ sender: Any) {
        // set up activity view controller
        let share = "\n\nDownload the app This Day In Collecting History at -LINK-"
        var shareText = dateText! + share
        let textToShare = [ shareText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //Allows the user to see what other facts are available for the day
    @IBAction func dateButton(_ sender: Any)
    {
        print(dateArray)
        if dateArray.count > 1 {
            self.table.reloadData()
            if (menuShowing){
                tableHeight.constant = 0
                UIView.animate(withDuration: 0.3,animations: {self.view.layoutIfNeeded()})
            }
            else{
                tableHeight.constant = 128
                UIView.animate(withDuration: 0.3,animations: {self.view.layoutIfNeeded()})
            }
            menuShowing = !menuShowing
        }
    }
    
    //Triggers the menu
    @IBAction func menuButton(_ sender: Any)
    {
        sideMenuWidth.constant = 203
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
    }
    
    //This function retrieves the number of facts for a day, which allows the user to change which day fact they are viewing (that part is not included in this function, for that, refer to tableView accessoryButtonTapped
    func getFacts(completionHandler: @escaping ([String])-> Void)
    {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        database.child(month).child(day).observeSingleEvent(of: .value, with: {(snapshot: FIRDataSnapshot!) in
            var array : [String] = []
            dateCount = snapshot.childrenCount
            var title : String = ""
            for i in 0 ..< dateCount{
                let count = Int(i)
                title = month
                title += "_"
                title += day
                title += String(alphabet[alphabet.index(alphabet.startIndex, offsetBy: count)])
                array += [title]
            }
            completionHandler(array)
        })
    }
    
    //This function counts how many pictures a specific fact has and pre-loads to get ready for the URLs
    func getPictureCount(completionHandler: @escaping ([String])-> Void)
    {
        database.child(month).child(day).child(whichFact).child(pFolder).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot!) in
            var array : [String] = []
            photoCount = snapshot.childrenCount
            for i in 0 ..< photoCount{
                var title : String = "Photo"
                title.append(String(i+1))
                array+=[title]
            }
            completionHandler(array)
        })
    }
    
    //This function retrieves the URLs for the photos and puts them into an array of String variables so that they can be put into one more array (I know, why so many? Swift is killing me :])
    func downloadPictureURL(completionHandler: @escaping (String)-> Void)
    {
        var word: String = ""
            database.child(month).child(day).child(whichFact).child(pFolder).child(whichPhoto).child(photoOne).observeSingleEvent(of: .value, with: { snapshot in
                if let val = snapshot.valueInExportFormat() as? String{
                    word = val
                }
                completionHandler(word)
            })
        
    }
    
    //This function allows for text to be loaded to the textView "textView", with month, day, whichFact,tFolder, and hotBod to load the text body, date to load the specific date
    func downloadText()
    {
        databaseRef = database.child(month).child(day).child(whichFact).child(tFolder).child(hotBod)
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
            let m = snapshot.valueInExportFormat() as? String
            // set the body text view
            self.textView.text = m
            dateText = m
        })
        databaseRef = database.child(month).child(day).child(whichFact).child(tFolder).child(date)
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
            let m = snapshot.valueInExportFormat() as? String
            // set the date label
            self.dateLabel.titleLabel?.adjustsFontSizeToFitWidth = true
            self.dateLabel.setTitle(m, for: .normal)
        })
    }
    
    //This function puts together all of the other member functions to be able to load pretty much everything about the UI. It's not as bad as it looks.
    func loadAll(completionHandler: @escaping ([String])-> Void)
    {
        self.downloadText()
        var array : [String] = []
        getFacts(completionHandler: { (data:[String]?) -> Void in
            if let dArray = data{
                dateArray = dArray
            self.getPictureCount(completionHandler: { (data:[String]?) -> Void in
                if let pArray = data{
                    photoArray = pArray
                    for i in 0 ..< photoArray.count{
                        whichPhoto = photoArray[i]
                        print(whichPhoto)
                        self.downloadPictureURL(completionHandler: { (data:String?) -> Void in
                            if let d = data{
                                print("success")
                                array.append(d)
                            }
                            print(array)
                            if i == (photoArray.count - 1)
                            {
                                
                                completionHandler(array)
                            }
                        })
                    }
                    
                }
            })
            }
        })
    }
}
