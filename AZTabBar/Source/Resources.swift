//
//  Resources.swift
//
//  Created by Antonio Zaitoun on 8/24/16.
//  Copyright © 2016 New Sound Interactive. All rights reserved.
//

import Foundation
import UIKit




struct AZTabBar{
    
    struct R {
        
        
        struct settings {
            
            //Allow scroll gesture
            static let scroll:Bool = false
            
            //Allow paging (Recommended if scroll is enabled)
            static let page:Bool = false
            
            //show seperator
            static let seprator = true
            
            //show seperator shadow (If the showSeperator is set to false then this is useless)
            static let shadow = true
        }
        
        struct ui {
            
            //Show opacity
            static let shadow:Float = 0.5
            
            //Button+Shadow corner radius
            static let radius:CGFloat = 5
            
            static let animation:Double  = 0.5
        }
        
        struct color {
            
            //Highlighted cell color
            static let highlight:UIColor = #colorLiteral(red: 0.876791656, green: 0.8812872767, blue: 0.8813701272, alpha: 1)
            
            //Seperator color (Recommended to match highlight color)
            static let seperator:UIColor = #colorLiteral(red: 0.876791656, green: 0.8812872767, blue: 0.8813701272, alpha: 1)
            
            //arrow buttons background color
            static let arrow:UIColor = UIColor.clear
            
            //menu button background color
            static let menu:UIColor = UIColor.clear
            
            //main tab background color (This matches the default system tab/tool bar colors)
            static let background = UIColor(red: (247.0 / 255.0), green: (247.0 / 255.0), blue: (247.0 / 255.0), alpha: 1)
            
        }
        
        struct xib {
            //The file name of the storyboard
            static let storyboard:String = "AZStickerTab"
            
            static let cellXib:String = "AZTabBarItemCell"
            
            //The id of the controller
            static let controller:String = "AZStickerTabController"
            
            static let scrollController:String = "AZTabBarScrollController"
            
            //The id of the cell
            static let cell:String = "AZTabBarItemCell"
            
            
        }
        
        struct assets {
            
            //File name of the menu icon
            static let menu:String = "ic_menu"
            
            //File name of the left arrow icon
            static let left:String = "ic_keyboard_arrow_left"
            
            //File name of the right arrow icon
            static let right:String = "ic_keyboard_arrow_right"
            
            static let close:String = "ic_close"
            
        }
        
        struct strings {
            
            struct error {
                
                static let change_index = "Error: You must set the data source before attempting to change the index."
                
                static let menu_not_enabled = "Error: Custom menu view is not enabled."
            }
            
            struct message {
                
            }
            
        }
        
    }
    
}



