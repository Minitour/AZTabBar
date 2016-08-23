//
//  AZTabBar+Protocol.swift
//  Sticker Tab Bar
//
//  Created by Antonio Zaitoun on 8/22/16.
//  Copyright © Crofis. All rights reserved.
//

import Foundation
import UIKit

public protocol AZTabBarDelegate {
    
    func stickerTabBar(_ tabBarController: AZTabBarController, didSelectMenu menu:UIView)
    
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToPage index:Int)
    
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToItem index:Int)
}

public protocol AZTabBarDataSource {
    
    func numberOfItemsInTabBar(_ tabBarController: AZTabBarController) -> Int

    // get the tab at index
    func stickerTabBar(_ tabBarController: AZTabBarController, tabViewForPageAtIndex index: Int) -> UIView
    
    // get the content at index
    func stickerTabBar(_ tabBarController: AZTabBarController, contentViewForPageAtIndex index: Int) -> ( contentView:UIView,controller:UIViewController?)
}
