//
//  AZTabBarItemCell.swift
//
//  Created by Antonio Zaitoun on 8/22/16.
//  Copyright © Crofis. All rights reserved.
//

import Foundation
import UIKit

class AZTabBarItemCell:UICollectionViewCell{
    
    
    static func id()->String {
        return AZTabBar.R.xib.cell
    }
    
    
    @IBOutlet weak var itemViewHolder: UIView!
    
    
}

class AZFlexableCell:UICollectionViewCell{
    
    
    static func id()->String {
        return "AZFlexableCell"
    }
    
    
    @IBOutlet weak var itemViewHolder: UIView!
    
    
}
