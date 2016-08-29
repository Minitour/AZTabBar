//
//  AZTabBarController.swift
//
//  Created by Antonio Zaitoun on 8/22/16.
//  Copyright © Crofis. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

public final class AZTabBarController:UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    public class func standardController()->AZTabBarController{
        return UIStoryboard(name: AZTabBar.R.xib.storyboard, bundle: Bundle(for: self)).instantiateViewController(withIdentifier: AZTabBar.R.xib.controller) as! AZTabBarController
    }
    
    
    /*
     * Outsider Views
     */
    
    //The tab bar
    @IBOutlet weak var tabBar: UIView!
    
    //The line (view) under the tab bar
    @IBOutlet weak var tabBarSeperatorLine: UIView!
    
    //The container that holdes the content
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var menuView: UIView!
    
    
    /*
     * Inner Views
     */
    
    //The menu button
    @IBOutlet weak var menuButton: UIButton!
    
    //The left scroll button
    @IBOutlet weak var leftScrollButton: UIButton!
    
    //The right scroll button
    @IBOutlet weak var rightScrollButton: UIButton!
    
    //The collectionview that holds the inner tabs
    @IBOutlet weak var collectionView: UICollectionView!
    
    //height of the seperator view
    @IBOutlet weak var seperatorConstraint: NSLayoutConstraint!
    
    
    /*
     * Custom Menu Views
     */
    
    //The Button inside the menuView
    @IBOutlet weak var menuDismissButton: UIButton!
    
    //Image View that is showen inside the custom menu view
    @IBOutlet weak var customMenuIcon: UIImageView!
    
    //Label View that is showen inside the custom menu view
    @IBOutlet weak var customMenuTitle: UILabel!
    
    //Seperator under the menuDismissButton, the customMenuIcon and CustomTitle
    @IBOutlet weak var customMenuSeperator: UIView!
    
    //Custom menu view holder
    @IBOutlet weak var customMenuView: UIView!
    
    //Menu tab that holds all the buttons
    @IBOutlet weak var customMenuTab: UIView!
    
    //The constraint of the custom menu seperator, we used this to show/hide the seperator
    @IBOutlet weak var menuSeperatorConstraint: NSLayoutConstraint!
    
    
    /*
     * Public Properties
     */
    
    //The delegate
    public var delegate:AZTabBarDelegate!
    
    //The data source
    public var dataSource:AZTabBarDataSource!
    
    //Background color of the tab bar
    public var tabBackgroundColor = AZTabBar.R.color.background
    
    //Background color of the navigation control buttons
    public var arrowBackgroundColor:UIColor = AZTabBar.R.color.arrow
    
    //tint color of the buttons
    public var arrowColor:UIColor!{
        didSet{
            if self.leftScrollButton == nil || self.rightScrollButton == nil {
            }else{
                self.leftScrollButton.tintColor = arrowColor
                self.rightScrollButton.tintColor = arrowColor
            }
        }
    }
    
    //Background color of the menu button
    public var menuBackgroundColor:UIColor = AZTabBar.R.color.menu
    
    //tint color of the menu button
    public var menuIconColor:UIColor!{
        didSet{
            if self.menuButton != nil {
                self.menuButton.tintColor = menuIconColor
            }
        }
    }
    
    //The color of the hairline (view) under the tab bar
    public var sepratorColor:UIColor = AZTabBar.R.color.seperator{
        didSet{
            if self.tabBarSeperatorLine != nil{
                self.tabBarSeperatorLine.backgroundColor = sepratorColor
            }
            
            if self.customMenuSeperator != nil {
                self.customMenuSeperator.backgroundColor = sepratorColor
            }
        }
    }
    
    //seperator height
    public var seperatorHeight:CGFloat = 1 {
        didSet{
            if self.seperatorConstraint != nil{
                if seperatorHeight != oldValue {
                    if showSeperator{
                        self.seperatorConstraint.constant = seperatorHeight
                    }
                }
            }
            
            if self.menuSeperatorConstraint != nil {
                if seperatorHeight != oldValue{
                    if showSeperator {
                        self.menuSeperatorConstraint.constant = seperatorHeight
                    }
                }
            }
            
        }
    }
    
    //Enable/Disable shadow
    public var allowSeperatorShadow:Bool = AZTabBar.R.settings.shadow{
        didSet{
            if self.tabBarSeperatorLine != nil {
                
                if allowSeperatorShadow != oldValue {
                    
                    if allowSeperatorShadow {
                        self.tabBarSeperatorLine.layer.masksToBounds = false
                        self.tabBarSeperatorLine.layer.shadowOffset = CGSize(width:0,height: 0)
                        self.tabBarSeperatorLine.layer.shadowRadius = AZTabBar.R.ui.radius
                        self.tabBarSeperatorLine.layer.shadowOpacity = AZTabBar.R.ui.shadow
                        
                        self.customMenuSeperator.layer.masksToBounds = false
                        self.customMenuSeperator.layer.shadowOffset = CGSize(width:0,height: 0)
                        self.customMenuSeperator.layer.shadowRadius = AZTabBar.R.ui.radius
                        self.customMenuSeperator.layer.shadowOpacity = AZTabBar.R.ui.shadow
                        
                    }else{
                        self.tabBarSeperatorLine.layer.masksToBounds = false
                        self.tabBarSeperatorLine.layer.shadowOffset = CGSize(width:0,height: 0)
                        self.tabBarSeperatorLine.layer.shadowRadius = AZTabBar.R.ui.radius
                        self.tabBarSeperatorLine.layer.shadowOpacity = 0
                        
                        self.customMenuSeperator.layer.masksToBounds = false
                        self.customMenuSeperator.layer.shadowOffset = CGSize(width:0,height: 0)
                        self.customMenuSeperator.layer.shadowRadius = AZTabBar.R.ui.radius
                        self.customMenuSeperator.layer.shadowOpacity = 0
                    }
                    
                }
            }
        }
    }
    
    //Hide/Show seperator
    public var showSeperator:Bool = AZTabBar.R.settings.seprator{
        didSet{
            if self.seperatorConstraint != nil {
                if showSeperator != oldValue {
                    if showSeperator {
                        self.seperatorConstraint.constant = seperatorHeight
                    }else{
                        self.seperatorConstraint.constant = 0
                    }
                }
            }
            
            if self.menuSeperatorConstraint != nil{
                if showSeperator != oldValue {
                    if showSeperator {
                        self.menuSeperatorConstraint.constant = seperatorHeight
                    }else{
                        self.menuSeperatorConstraint.constant = 0
                    }
                }
            }
        }
    }
    
    //The background color of inner tabs when highlighted
    public var highlightedItemColor:UIColor = AZTabBar.R.color.highlight
    
    //Enable or Disable the scroll view of the collection view
    public var isScrollEnabled:Bool = AZTabBar.R.settings.scroll {
        didSet{
            if self.collectionView != nil {
                self.collectionView.isScrollEnabled = isScrollEnabled
            }
        }
    }
    
    public var isPagingEnabled:Bool = AZTabBar.R.settings.page {
        didSet{
            if self.collectionView != nil {
                self.collectionView.isPagingEnabled = isPagingEnabled
            }
        }
    }
    
    //The Current Selected Index
    public var currentIndex:Int = 0{
        didSet{
            //assert index
            if self.dataSource != nil {
                if self.currentIndex >= self.dataSource.numberOfItemsInTabBar(self){
                    currentIndex = 0
                }
            }else {
                //Attempt to change the current index before setting the data source.
                currentIndex = 0
                print(AZTabBar.R.strings.error.change_index)
            }
        }
    }
    
    //Allow custom menu view, false by default
    public var isCustomMenuEnabled = false
    
    //Show/Hide the custom Menu View, true by default, meaning the controller will launch with the menu view hidden.
    public var isMenuViewHidden = true {
        didSet{
            if isCustomMenuEnabled {
             
                if self.menuView != nil {
                    
                    if isMenuViewHidden != oldValue {
                       self.menuView.isHidden = isMenuViewHidden
                    }
                }
                
            }else{
                print(AZTabBar.R.strings.error.menu_not_enabled)
            }
        }
    }
    
    /*
     * Private Properties
     */
    
    //The current page we are in
    private var currentPage:Int = 0 {
        didSet{
            
            if currentPage != oldValue {
                self.delegate.stickerTabBar!(self, didChangeToPage: currentPage,from: oldValue)
            }
        }
    }
    
    //Track menu animations to disable interaction when needed
    private var isMenuViewAnimating = false {
        didSet{
            menuButton.isUserInteractionEnabled = !isMenuViewAnimating
            menuDismissButton.isUserInteractionEnabled = !isMenuViewAnimating
        }
    }
    
    //This index points to the first item of the current page
    private var selectedHiddenItem = 0
    
    //DO NOT CHANGE THIS - This is a fixed number that matches with the interface builder
    private let itemPerPage = 5 //If you change this you doom us all
    
    //The amount of items that the collectionview holds
    private var itemAmount:Int = 0
    
    //The number of pages that are needed to display the items
    private var pageAmount:Int = 0
    
    //global flag, Do no change - used to check if the index was highlighted (starting index)
    private var didInitHighlight = false
    
    //global flag, set to true once viewDidLoad has finished.
    private var didInit = false
    
    
    /*
     * UIViewController Methods
     */
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable multi selection
        self.collectionView.allowsMultipleSelection = false
        
        //Enable selection
        self.collectionView.allowsSelection = true
        
        //Set the delegate
        self.collectionView.delegate = self
        
        //Set the data source
        self.collectionView.dataSource = self
        
        //Setup collection scroll setting
        self.collectionView.isScrollEnabled = isScrollEnabled
        
        self.collectionView.isPagingEnabled = isPagingEnabled
        
        
        //Register AZTabBarItemCell
        self.collectionView.register(UINib(nibName: AZTabBar.R.xib.cellXib, bundle: nil), forCellWithReuseIdentifier: AZTabBarItemCell.id())
        
        //Setup item amount
        self.itemAmount = self.dataSource.numberOfItemsInTabBar(self)
        
        //calculate pages needed, formula: case items is not divided by the amount of items per page, pages that are needed will be item amount divided by item per page + 1, else there won't be a +1.
        self.pageAmount =  itemAmount%itemPerPage != 0 ? (itemAmount - (itemAmount % itemPerPage)) / itemPerPage  + 1 : (itemAmount - (itemAmount % itemPerPage)) / itemPerPage
        
        //Setup functions (connection buttons to selectors, etc)
        initFunctionality()
        
        //Init design - colors,shapes...
        initUiDesign()
        
        //Set the page using the selected index
        switchTab(to: currentIndex, from: -1  )
        
        
        
        
        didInit = true
        
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.selectedHiddenItem = currentIndex % itemPerPage != 0 ? currentIndex - (currentIndex % itemPerPage)  : currentIndex
        self.currentPage = Int(selectedHiddenItem/itemPerPage)
        
        self.collectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: false, scrollPosition: [])
        
        //Init the cell
        let cell = self.collectionView.cellForItem(at: IndexPath(item: self.currentIndex, section: 0))
        
        //Set the cell as selected
        cell?.isSelected = true
        
        scroll(to: self.selectedHiddenItem, animated: false)
        lockControlls(lock: false)
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //Method is called when orientation is changed
        
        //Once screen size has changed -> wait for animation to finish.
        coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
            }, completion: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                
                //Reload data -> to recalculate the sizes of the cells
                self.collectionView.performBatchUpdates({
                    //On completion -> reload that data and reselect the selected index (highlight it)
                    self.collectionView.reloadData()
                    
                    }, completion: { (Bool) in
                        
                        //update params
                        //self.selectedHiddenItem = self.currentIndex % self.itemPerPage != 0 ? self.currentIndex - (self.currentIndex % self.itemPerPage)  : self.currentIndex
                        //self.currentPage = Int(self.selectedHiddenItem/self.itemPerPage)
                        
                        //Set the index as selected
                        self.collectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: true, scrollPosition: [])
                        
                        //Init the cell
                        let cell = self.collectionView.cellForItem(at: IndexPath(item: self.currentIndex, section: 0))
                        
                        //Set the cell as selected
                        cell?.isSelected = true
                        
                        //Scroll to the selected section (because when reloading we will be at the first index) with no animation
                        self.collectionView.scrollToItem(at: IndexPath(item: self.selectedHiddenItem, section: 0), at: .left, animated: true)
                        
                })
        })
    }
    
    
    /*
     * UICollectionView Delegate and DataSource methods
     */
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInTabBar(self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Dequeue cell
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: AZTabBarItemCell.id(), for: indexPath) as! AZTabBarItemCell
        
        //Reset cell - remove all subviews from itemViewHolder
        for view in itemCell.itemViewHolder.subviews {
            view.removeFromSuperview()
        }
        
        //Init a view from the dataSource
        let view = self.dataSource.stickerTabBar(self, tabViewForPageAtIndex: indexPath.item)
        
        //Add the view
        itemCell.itemViewHolder.addSubview(view)
        
        //Setup autolayout - Uses SnapKit to to match the subview to the item view holder
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(itemCell.itemViewHolder)
        }
        
        //Highlight cell if selected
        if didInitHighlight == false && indexPath.item == currentIndex {
            
            //Scroll to cell (if needed)
            collectionView.scrollToItem(at: IndexPath(item: self.selectedHiddenItem, section: 0), at: .left, animated: false)
            
            //select cell
            collectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: false, scrollPosition: [])
            
            //set cell as selected
            itemCell.isSelected = true
            
            //Disable flag
            didInitHighlight = true
        }
        
        //Highlight cell if it is selected
        if indexPath.item == currentIndex {
            itemCell.backgroundColor = highlightedItemColor
        }else{
            itemCell.backgroundColor = UIColor.clear
        }
        
        return itemCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Return the size of the cells as square using the UICollectionView's height.
        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Check if cell was not already selected
        if indexPath.item != currentIndex {
            
            //Switch container view
            self.switchTab(to: indexPath.item,from: currentIndex)
            
            //Highlight cell
            let cell = self.collectionView.cellForItem(at: indexPath) as! AZTabBarItemCell
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            cell.backgroundColor = highlightedItemColor
            
            //update current index
            self.currentIndex = indexPath.item
            
            //Call delegate methods
            self.delegate.stickerTabBar!(self, didChangeToItem: currentIndex)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //Change un-highlight the cell that was deselected
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
        cell?.backgroundColor = UIColor.clear
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == currentIndex {
            cell.backgroundColor = highlightedItemColor
        }else{
            cell.backgroundColor = UIColor.clear
        }
        
        
        //Update leftScrollButton case reached the left edge
        if indexPath.item == 0 {
            self.selectedHiddenItem = 0
            leftScrollButton.isEnabled = false
        }
        //Update rightScrollButton case reached the right edge
        if indexPath.item == itemAmount - 1 {
            self.selectedHiddenItem = itemAmount % itemPerPage == 0 ? itemAmount - (itemAmount % itemPerPage) - itemPerPage :  itemAmount - (itemAmount % itemPerPage)
            rightScrollButton.isEnabled = false
        }
        
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Update leftScrollButton case the left edge is not showing
        if indexPath.item == 0 {
            leftScrollButton.isEnabled = true
        }
        
        //Update rightScrollButton case the right edge is not showing
        if indexPath.item == itemAmount - 1 {
            rightScrollButton.isEnabled = true
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //Unlock controlls after scroll animation is finished
        self.lockControlls(lock: false)
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(Int(scrollView.contentOffset.x)/(Int(self.collectionView.frame.size.height) * self.itemPerPage))
        if self.currentPage != page {
            self.currentPage = page
            
        }
    }
    
    
    /*
     * Private Methods
     */
    
    private func switchTab(to index:Int,from oldIndex:Int){
        
        //Remove any subviews from the container
        for view in self.viewContainer.subviews {
            view.removeFromSuperview()
        }
        
        //remove old controller from parent controller
        if oldIndex != -1 {
            if let oldViewController = self.dataSource.stickerTabBar(self, contentViewForPageAtIndex: oldIndex).controller {
                oldViewController.removeFromParentViewController()
            }
        }
        
        //Add child view controller if found
        if let childController = self.dataSource.stickerTabBar(self, contentViewForPageAtIndex: index).controller {
            self.addChildViewController(childController)
        }
        
        //Init the view using the data source
        let view = self.dataSource.stickerTabBar(self, contentViewForPageAtIndex: index).contentView
        
        //Insert the container at the bottom
        self.viewContainer.addSubview(view)
        
        //call did move on the new controller
        if let childController = self.dataSource.stickerTabBar(self, contentViewForPageAtIndex: index).controller {
            childController.didMove(toParentViewController: self)
        }
        
        //setup layout constaints
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(self.viewContainer)
        }
        
        //init custom menu view
        
        if self.isCustomMenuEnabled {
            
            for view in self.customMenuView.subviews {
                view.removeFromSuperview()
            }
            
            if let subView = self.dataSource.stickerTabBar(self, menuViewForIndex: index).view {
                self.customMenuView.addSubview(subView)
                
                subView.snp_makeConstraints(closure: { (make) in
                    make.edges.equalTo(self.customMenuView)
                })
            }
            
            if let image = self.dataSource.stickerTabBar(self, menuViewForIndex: index).icon {
                self.customMenuIcon.isHidden = false
                self.customMenuIcon.image = image
            }else{
                self.customMenuIcon.isHidden = true
                self.customMenuIcon.image = nil
            }
            
            if let title = self.dataSource.stickerTabBar(self, menuViewForIndex: index).title {
                self.customMenuTitle.isHidden = false
                self.customMenuTitle.text = title
            }else{
                self.customMenuTitle.isHidden = true
                self.customMenuTitle.text = ""
            }
        }
        
    }
    
    private func initUiDesign(){
        
        //init colors
        if self.arrowColor == nil {
            self.arrowColor = self.view.tintColor
        }
        
        if self.menuIconColor == nil {
            self.menuIconColor = self.view.tintColor
        }
        
        //setup tab bar background color
        self.tabBar.backgroundColor = self.tabBackgroundColor
        
        //setup hairline
        self.tabBarSeperatorLine.backgroundColor = self.sepratorColor
        
        self.customMenuSeperator.backgroundColor = self.sepratorColor
        
        //setup shadow - if enabled
        if allowSeperatorShadow {
            self.tabBarSeperatorLine.layer.masksToBounds = false
            self.tabBarSeperatorLine.layer.shadowOffset = CGSize(width:0,height: 0)
            self.tabBarSeperatorLine.layer.shadowRadius = AZTabBar.R.ui.radius
            self.tabBarSeperatorLine.layer.shadowOpacity = AZTabBar.R.ui.shadow
            
            self.customMenuSeperator.layer.masksToBounds = false
            self.customMenuSeperator.layer.shadowOffset = CGSize(width:0,height: 0)
            self.customMenuSeperator.layer.shadowRadius = AZTabBar.R.ui.radius
            self.customMenuSeperator.layer.shadowOpacity = AZTabBar.R.ui.shadow
        }
        
        //setup seperator height
        if showSeperator {
            self.seperatorConstraint.constant = seperatorHeight
            self.menuSeperatorConstraint.constant = seperatorHeight
            
        }else{
            self.seperatorConstraint.constant = 0
            self.menuSeperatorConstraint.constant = 0
        }
        
        
        //setup collection view design
        self.collectionView.backgroundColor = self.tabBackgroundColor
        
        //init inner menu view design
        self.menuView.backgroundColor = self.tabBackgroundColor
        self.customMenuTab.backgroundColor = self.tabBackgroundColor
        self.customMenuView.backgroundColor = self.tabBackgroundColor
        
        
        //setup menu button design
        self.menuButton.setBackgroundImage(getImageWithColor(color: self.menuBackgroundColor, size: self.menuButton.bounds.size), for: [])
        self.menuButton.setBackgroundImage(getImageWithColor(color: self.menuBackgroundColor, size: self.menuButton.bounds.size), for: UIControlState.highlighted)
        self.menuButton.layer.cornerRadius = AZTabBar.R.ui.radius
        self.menuButton.clipsToBounds = true
        self.menuButton.tintColor = menuIconColor
        
        //setup dismiss menu button design
        self.menuDismissButton.setBackgroundImage(getImageWithColor(color: self.menuBackgroundColor, size: self.menuButton.bounds.size), for: [])
        self.menuDismissButton.setBackgroundImage(getImageWithColor(color: self.menuBackgroundColor, size: self.menuButton.bounds.size), for: UIControlState.highlighted)
        self.menuDismissButton.layer.cornerRadius = AZTabBar.R.ui.radius
        self.menuDismissButton.clipsToBounds = true
        self.menuDismissButton.tintColor = menuIconColor
        
        
        //setup left/right arrow design
        self.leftScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: [])
        self.leftScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: UIControlState.highlighted)
        self.leftScrollButton.layer.cornerRadius = AZTabBar.R.ui.radius
        self.leftScrollButton.clipsToBounds = true
        
        self.rightScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: [])
        self.rightScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: UIControlState.highlighted)
        self.rightScrollButton.layer.cornerRadius = AZTabBar.R.ui.radius
        self.rightScrollButton.clipsToBounds = true
        
        self.rightScrollButton.tintColor = arrowColor
        self.leftScrollButton.tintColor = arrowColor
        
        //Setup icons
        self.leftScrollButton.setImage(UIImage(named:AZTabBar.R.assets.left), for: [])
        self.rightScrollButton.setImage(UIImage(named:AZTabBar.R.assets.right), for: [])
        self.menuButton.setImage(UIImage(named:AZTabBar.R.assets.menu), for: [])
        self.menuDismissButton.setImage(UIImage(named: AZTabBar.R.assets.close), for: [])
        
    }
    
    private func initFunctionality(){
        
        //Add targets to buttons
        self.leftScrollButton.addTarget(self, action: #selector(AZTabBarController.scrollLeft(sender:)), for: .touchUpInside)
        self.rightScrollButton.addTarget(self, action: #selector(AZTabBarController.scrollRight(sender:)), for: .touchUpInside)
        
        var longClickGesture = UILongPressGestureRecognizer(target: self, action: #selector(AZTabBarController.fullScrollLeft(sender:)))
        self.leftScrollButton.addGestureRecognizer(longClickGesture)
        longClickGesture = UILongPressGestureRecognizer(target: self, action: #selector(AZTabBarController.fullScrollRight(sender:)))
        self.rightScrollButton.addGestureRecognizer(longClickGesture)
        
        self.menuButton.addTarget(self, action: #selector(AZTabBarController.clickMenu(sender:)), for: .touchUpInside)
        
        self.menuDismissButton.addTarget(self, action: #selector(AZTabBarController.clickDismissMenu(sender:)), for: .touchUpInside)
        
        self.leftScrollButton.isExclusiveTouch = true
        self.rightScrollButton.isExclusiveTouch = true
        self.menuButton.isExclusiveTouch = true
        
        
        
        
    }
    
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        //fucntion used for design
        let rect = CGRect(x:0,y: 0, width: size.width,height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func scroll(to index:Int,animated:Bool){
        //Assert index
        if index >= 0 && index < self.itemAmount {
            //lock controls before scroll
            //lockControlls(lock: true)
            
            //Scroll to index
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: animated)
        }
    }
    
    public func lockControlls(lock:Bool){
        //enable/disable interaction with buttons
        self.leftScrollButton.isUserInteractionEnabled = !lock
        self.rightScrollButton.isUserInteractionEnabled = !lock
    }
    
    public func scrollLeft(sender:AnyObject){
        
        //Check if we are on the right edge
        if selectedHiddenItem >= itemAmount - 1 /*itemAmount - (itemAmount % itemPerPage)*/ {
            
            //correct the index
            selectedHiddenItem = itemAmount - (itemAmount % itemPerPage) //- itemPerPage
            
            //scroll to the first item of the previous page
            scroll(to: selectedHiddenItem, animated: true)
            
        }
            //else - we are in the middle
        else{
            //decrease the selected hidden item by "itemPerPage"
            selectedHiddenItem -= itemPerPage
            
            //assert - case we have already reached the edge (this won't happen since the button will be disabled automatically)
            if selectedHiddenItem < 0 {
                selectedHiddenItem = 0
            }
            
            //scroll to index
            scroll(to: selectedHiddenItem, animated: true)
        }
        
        //update current page
        self.currentPage = Int(selectedHiddenItem/itemPerPage)
        
        //call delegate method
        
    }
    
    public func scrollRight(sender:AnyObject){
        
        //increase by 'itemPerPage'
        selectedHiddenItem += itemPerPage
        
        //assert
        if selectedHiddenItem >= itemAmount {
            
            //make corrections
            
            //selectedHiddenItem = itemAmount - (itemAmount % itemPerPage) - itemPerPage
            self.selectedHiddenItem = itemAmount % itemPerPage == 0 ? itemAmount - (itemAmount % itemPerPage) - itemPerPage :  itemAmount - (itemAmount % itemPerPage)
        }
        
        //scroll to index
        scroll(to: selectedHiddenItem, animated: true)
        
        //update current page
        self.currentPage = Int(selectedHiddenItem/itemPerPage)
        
        //call delegate method
        
    }
    
    public func fullScrollLeft(sender:AnyObject){
        
        //selected hidden item = 0 , since the first index will always be 0
        selectedHiddenItem = 0
        
        //scroll to index
        scroll(to: selectedHiddenItem, animated: true)
        
        //lock control - to prevent multiple unwanted events
        self.lockControlls(lock: false)
        
        //update if needed
        if self.currentPage != 0 {
            self.currentPage = 0
            
        }
    }
    
    public func fullScrollRight(sender:AnyObject){
        
        //Selected hidden item = the first index in the last page
        
        //selectedHiddenItem = itemAmount - (itemAmount % itemPerPage) - itemPerPage
        self.selectedHiddenItem = itemAmount % itemPerPage == 0 ? itemAmount - (itemAmount % itemPerPage) - itemPerPage :  itemAmount - (itemAmount % itemPerPage)
        
        //scroll to index
        scroll(to: selectedHiddenItem, animated: true)
        
        //lock controls
        self.lockControlls(lock: false)
        
        //update if needed
        if self.currentPage != Int(selectedHiddenItem/itemPerPage) {
            self.currentPage = Int(selectedHiddenItem/itemPerPage)
            
        }
        
    }
    
    public func clickMenu(sender: UIView){
        self.delegate.stickerTabBar!(self, didSelectMenu: sender,at:currentIndex)
        if isCustomMenuEnabled {setMenu(hidden: false, animated: true)}
        
    }
    
    public func clickDismissMenu(sender: UIView){
        self.delegate.stickerTabBar!(self, didCloseMenu: sender, at: currentIndex)
        if isCustomMenuEnabled{setMenu(hidden: true, animated: true)}
    }
    
    private func showCustomMenu(for view:UIView,to point:CGRect){
        
        //Change view visibility - we do this so we can actually see what is happening, remove this line and we won't see any changes.
        view.isHidden = false
        
        //copy bounds - for convenience
        let bounds = view.bounds
        
        //get the diameter
        let maskDiameter = CGFloat(sqrt(powf(Float(view.bounds.width), 2)
            + powf(Float(view.bounds.height), 2)) * 2)
        //Create CAShapeLayer object
        let rectShape = CAShapeLayer()
        
        //Set the bounds of the shape to match our current view bounds
        rectShape.bounds = bounds
        
        //Set the center point - make to to match the view we are hiding
        rectShape.position = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y)
        
        //Set the corner radius to match our maskDiameter value
        rectShape.cornerRadius = maskDiameter
        
        //Set the CAShapeLayer object 'rectShape' on our view.layer.mask
        view.layer.mask = rectShape
        
        //Mask layer to bounds - must have this, otherwise we won't see anything happening
        view.layer.masksToBounds = true
        
        //Set the start shape using the origin of the given CGRect 'point' with width and height of 0. This is because we are showing the view, and so the mask must start with size of 0
        let startShape = UIBezierPath(roundedRect: CGRect(x: point.origin.x, y: point.origin.y, width: 0, height: 0), cornerRadius: 0).cgPath
        
        //Set the end shape using the original bounds of our rect. We can do that because the values (width and height) of the rect itself are not changing when we hide/show the view. The only thing that is changing is the layer mask and therefor we can relay on the original bounds and origin point of the rect as parameters for the end shape.
        let endShape = UIBezierPath(roundedRect: CGRect(origin: bounds.origin, size: CGSize(width: maskDiameter, height: maskDiameter)), cornerRadius: maskDiameter).cgPath
        
        //Set the path as current shape - note that rectShape is a pointer to view.layer.mask, so by doing that we are modifying the mask of the view.
        rectShape.path = startShape
        
        //Begin a new transaction for the current thread.
        CATransaction.begin()
        
        //Set the flag 'isMenuViewAnimating' to true.
        self.isMenuViewAnimating = true
        
        //Create the animation object
        let animation = CABasicAnimation(keyPath: "path")
        
        //Set the animation toValue to 'endShape'
        animation.toValue = endShape
        
        //Set the duration of the animation
        animation.duration = AZTabBar.R.ui.animation
        
        //An optional timing function defining the pacing of the animation.
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        //keep to value (layer.mask) after finishing
        animation.fillMode = kCAFillModeBoth
        
        //When true, the animation is removed from the target layer’s animations once its active duration has passed.
        animation.isRemovedOnCompletion = false
        
        //After transaction is completeded (animation is over)
        CATransaction.setCompletionBlock {
            
            //remove the mask
            view.layer.mask?.removeFromSuperlayer()
            
            //change the menu view animating flag
            self.isMenuViewAnimating = false
        }
        
        //Add the aniation to our rectShape object (pointer to view.layer.mask)
        rectShape.add(animation, forKey: animation.keyPath)
        
        //Commit all changes made during the current transaction.
        CATransaction.commit()
        
    }
    
    private func hideCustomMenu(for view:UIView,to point:CGRect){
        
        let bounds = view.bounds
        
        //calculate diamter
        let maskDiamter = CGFloat(sqrt(powf(Float(view.bounds.width), 2) + powf(Float(view.bounds.height), 2)) * 2)
        
        //Create CAShapeLayer object
        let rectShape = CAShapeLayer()
        
        //set the layer bounds to current bounds of the view
        rectShape.bounds = bounds
        
        //set the position of the layer using the current point (origin) of the view
        rectShape.position = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y)
        
        //set the corner radius as the mask diamter
        rectShape.cornerRadius = maskDiamter
        
        //set the layer as mask for the view which we wanna hide
        view.layer.mask = rectShape
        
        //set mask to bounds - this is important
        view.layer.masksToBounds = true
        
        //create the start path using the view's current paramters
        //@roundedRect - origin: is where the animation will start,size: is the size of the showing animation make sure its width and height are using the mask diamter value
        let startShape = UIBezierPath(roundedRect: CGRect(origin: bounds.origin, size: CGSize(width: maskDiamter, height: maskDiamter)), cornerRadius: maskDiamter).cgPath
        
        //endShape is where the layer should end up, with the origin of the object "point" we provided as parameter. Height and Width must be set to 0, since we are hiding the view.
        let endShape = UIBezierPath(roundedRect: CGRect(x: point.origin.x, y: point.origin.y, width: 0, height: 0), cornerRadius: 0).cgPath
        
        //Set the path on rectShape (which is a pointer to out layer.mask)
        rectShape.path = startShape
        
        //mark animation begining
        CATransaction.begin()
        self.isMenuViewAnimating = true
        
        //Create CABasicAnimation object, to animate with key "path"
        let animation = CABasicAnimation(keyPath: "path")
        
        //set the to value the end shape (our goal shape)
        animation.toValue = endShape
        
        //set the duration of the animation
        animation.duration = AZTabBar.R.ui.animation
        
        //set timing function, to keep it smooth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // keep to value after finishing
        animation.fillMode = kCAFillModeBoth
        
        animation.isRemovedOnCompletion = false
    
        //Add completion block, will be called upon end of animation
        CATransaction.setCompletionBlock { 
            view.isHidden = true
            view.layer.mask?.removeFromSuperlayer()
            self.isMenuViewAnimating = false
        }
        
        //add the animation to the rectShape object (our pointer to view.layer.mask)
        rectShape.add(animation, forKey: animation.keyPath)
        
        //commit tranasaction
        CATransaction.commit()
        
    }
    
    /*
     * Public Methods
     */
    
    public func setMenu(hidden toHide:Bool, animated:Bool){
        if isCustomMenuEnabled {
            if toHide {
                if animated {
                    hideCustomMenu(for: menuView,to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0,height: 0)))
                }
                self.isMenuViewHidden = true
            }else{
                if animated {
                    showCustomMenu(for: menuView, to: menuView.bounds)
                }
                else {
                    self.isMenuViewHidden = false
                }
            }
        }else{
            print(AZTabBar.R.strings.error.menu_not_enabled)
        }
        
    }
    
    public func selectedPage()->Int {
        return self.currentPage
    }
    
    public func reloadData(){
        collectionView.reloadData()
        initUiDesign()
    }
    
}



