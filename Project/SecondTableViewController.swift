//
//  SecondTableView.swift
//  History
//
//  Created by Eric Larsen on 1/14/17.
//  Copyright © 2017 N00B$. All rights reserved.
//

import Foundation
import UIKit

class SecondTableViewController: UITableViewController{
    
    var SecondArray = [String]()
    var SecondAnswerArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Tells tableView how many cells to create (dependent upon how many days are in the month selected from the first table)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SecondArray.count
    }
    
    //creates the table cells for the second table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as UITableViewCell
        Cell.textLabel?.text = SecondArray[indexPath.row]
        return Cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
        var DestViewController = segue.destination as! ViewController
        DestViewController.FirstString = SecondAnswerArray[indexPath.row]
    }
}

