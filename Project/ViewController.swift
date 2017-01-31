//
//  ViewController.swift
//  History
//
//  Created by Eric Larsen on 1/15/17.
//  Copyright © 2017 N00B$. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController
{
    var FirstString = String()

    @IBOutlet weak var TextView: UITextView!

    override func viewDidLoad() {
     TextView.text=FirstString
    }
}
