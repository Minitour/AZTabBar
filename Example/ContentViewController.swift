//
//  ContentViewController.swift
//  Example
//
//  Created by Antonio Zaitoun on 8/25/16.
//  Copyright © 2016 New Sound Interactive. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController:UIViewController {
    
    
    public var textToDisplay:String!
    
    public var backgroundColor:UIColor!
    
    @IBOutlet var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.backgroundColor
        self.label.text = textToDisplay
    }
    
}
