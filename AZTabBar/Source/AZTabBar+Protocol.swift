//
//  AZTabBar+Protocol.swift
//
//  Created by Antonio Zaitoun on 8/22/16.
//  Copyright © Crofis. All rights reserved.
//

import Foundation
import UIKit

public protocol AZTabBarDelegate {
    
    /*
     * Triggered when clicking the menu button.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, didSelectMenu menu:UIView)
    
    /*
     * Triggered when navigating between pages.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToPage index:Int)
    
    /*
     * Triggered when changing to a new item.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToItem index:Int)
}

public protocol AZTabBarDataSource {
    
    /*
     * Returns the amount of items inside the tab.
     */
    func numberOfItemsInTabBar(_ tabBarController: AZTabBarController) -> Int

    /*
     * The UIView per index that will be inside the tab.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, tabViewForPageAtIndex index: Int) -> UIView
    
    /*
     * contentView:UIView - is the content that will be presented inside the content holder.
     * controller:UIViewController - is the UIViewController that holds the content view (if exists).
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, contentViewForPageAtIndex index: Int) -> ( contentView:UIView,controller:UIViewController?)
}
