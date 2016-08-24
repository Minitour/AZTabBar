# AZTabBar
A Tab Bar that does not require a swipe gesture to navigate

##Screenshots
<img src="Screenshot/Simulator%20Screen%20Shot%20Aug%2024%2C%202016%2C%209.09.23%20PM.png"  height="300" />

<img src="Screenshot/Simulator%20Screen%20Shot%20Aug%2024%2C%202016%2C%209.09.28%20PM.png"  height="200" />

##Installation

Simply drag and drop the ```AZTabBar``` folder to your project.

##Usage

Implement the delegate and the data source protocols:
```swift
class ViewController: UIViewController,AZTabBarDelegate,AZTabBarDataSource {

    /*
     * Returns the amount of items inside the tab.
     */
    func numberOfItemsInTabBar(_ tabBarController: AZTabBarController) -> Int {
        return size
    }
    
    /*
     * Triggered when changing to a new item.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToItem index: Int) {
        print("Item Clicked: \(index+1)")
    }
    
    /*
     * Triggered when navigating between pages.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToPage index:Int ,from oldPage:Int) {
        print("Current Page \(index+1)")
    }
    
    /*
     * Triggered when clicking the menu button.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, didSelectMenu menu: UIView) {
        print("Menu Clicked")
    }
    
    /*
     * The UIView per index that will be inside the tab.
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, tabViewForPageAtIndex index: Int) -> UIView {
        return UIView() //Replace this with the view that will be inside the tab
    }
    
    /*
     * contentView:UIView - is the content that will be presented inside the content holder.
     * controller:UIViewController - is the UIViewController that holds the content view (if exists).
     */
    func stickerTabBar(_ tabBarController: AZTabBarController, contentViewForPageAtIndex index: Int) -> (contentView: UIView, controller: UIViewController?) {
        return (UIView()/*insert your view*/,nil/*insert your controller (if exists)*/)
    }
}
```

Now the controller initialize:

```swift
        let tabBarController = AZTabBarController.standardController()
```

Set the delegate and the data source:
```swift
        tabBarController.delegate = self
        tabBarController.dataSource = self
        //Do any additianl customizations
```

Add it as a child view controller:
```swift
        addChildViewController(tabBarController)
```

And finally add the sub view:

```swift
        tabBarController.view.frame = self.view.frame
        self.view.addSubview(tabBarController.view)
```


##Extra Customizations
Checkout the ```Resources.swift``` file:

```swift
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
    
    /*DO NOT MODIFY ANYTHING UNDER THE XIB STRUCT*/
    struct xib {
        //The file name of the storyboard
        static let storyboard:String = "AZStickerTab"
        
        //The id of the controller
        static let controller:String = "AZStickerTabController"
        
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
        
    }
    
}

```
