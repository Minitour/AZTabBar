//
//  AZTabBarScroll+Protocol.swift
//  Example
//
//  Created by Antonio Zaitoun on 8/25/16.
//  Copyright © 2016 New Sound Interactive. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol AZTabBarScrollableDelegate {
    
    /*
     * Triggered when clicking the menu button.
     */
    @objc optional func stickerTabBar(_ tabBarController: AZTabBarScrollController, didSelectMenu menu:UIView)
    
    /*
     * Triggered when navigating between pages.
     */
    @objc optional func stickerTabBar(_ tabBarController: AZTabBarScrollController, didChangeToPage index:Int ,from oldPage:Int)
    
    /*
     * Triggered when changing to a new item.
     */
    @objc optional func stickerTabBar(_ tabBarController: AZTabBarScrollController, didChangeToItem index:Int)
}

public protocol AZTabBarScrollableDataSource {
    
    /*
     * Returns the amount of items inside the tab.
     */
    func numberOfItemsInTabBar(_ tabBarController: AZTabBarScrollController) -> Int
    
    /*
     * The UIView per index that will be inside the tab.
     */
    func stickerTabBar(_ tabBarController: AZTabBarScrollController, tabViewForPageAtIndex index: Int) -> UIView
    
    /*
     * contentView:UIView - is the content that will be presented inside the content holder.
     * controller:UIViewController - is the UIViewController that holds the content view (if exists).
     */
    func stickerTabBar(_ tabBarController: AZTabBarScrollController, contentViewForPageAtIndex index: Int) -> ( contentView:UIView,controller:UIViewController?)
}
