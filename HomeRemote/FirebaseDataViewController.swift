//
//  FirebaseDataViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/2/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit

class FirebaseDataViewController: UIViewController {
    
    var prefRef = ""
    var githubLink = ""
    var titleData = ""
    var descriptionData = ""
    var authorData = ""
    var remoteTypeData = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    
    
    override func viewDidLoad() {
        print("data link:"  + githubLink)
        titleLabel.text = titleData
        descriptionText.text = descriptionData
        
    }
    
}
