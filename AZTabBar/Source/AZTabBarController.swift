//
//  AZTabBarController.swift
//
//  Created by Antonio Zaitoun on 8/22/16.
//  Copyright © Crofis. All rights reserved.
//

import Foundation
import UIKit

public final class AZTabBarController:UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    public class func standardController()->AZTabBarController{
        return UIStoryboard(name: R.xib.storyboard, bundle: Bundle(for: self)).instantiateViewController(withIdentifier: R.xib.controller) as! AZTabBarController
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
    
    @IBOutlet weak var seperatorConstraint: NSLayoutConstraint!
    
    /*
     * Public Properties
     */
    
    //The delegate
    public var delegate:AZTabBarDelegate!
    
    //The data source
    public var dataSource:AZTabBarDataSource!
    
    //Background color of the tab bar
    public var tabBackgroundColor = R.color.background
    
    //Background color of the navigation control buttons
    public var arrowBackgroundColor:UIColor = R.color.arrow
    
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
    public var menuBackgroundColor:UIColor = R.color.menu
    
    //tint color of the menu button
    public var menuIconColor:UIColor!{
        didSet{
            if self.menuButton != nil {
                self.menuButton.tintColor = menuIconColor
            }
        }
    }
    
    //The color of the hairline (view) under the tab bar
    public var sepratorColor:UIColor = R.color.seperator{
        didSet{
            if self.tabBarSeperatorLine != nil{
                self.tabBarSeperatorLine.backgroundColor = sepratorColor
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
        }
    }
    
    //Enable/Disable shadow
    public var allowSeperatorShadow:Bool = R.settings.shadow{
        didSet{
            if self.tabBarSeperatorLine != nil {
                
                if allowSeperatorShadow != oldValue {
                    
                    if allowSeperatorShadow {
                        self.tabBarSeperatorLine.layer.masksToBounds = false
                        self.tabBarSeperatorLine.layer.shadowOffset = CGSize(width:0,height: 0)
                        self.tabBarSeperatorLine.layer.shadowRadius = R.ui.radius
                        self.tabBarSeperatorLine.layer.shadowOpacity = R.ui.shadow
                    }else{
                        self.tabBarSeperatorLine.layer.masksToBounds = false
                        self.tabBarSeperatorLine.layer.shadowOffset = CGSize(width:0,height: 0)
                        self.tabBarSeperatorLine.layer.shadowRadius = R.ui.radius
                        self.tabBarSeperatorLine.layer.shadowOpacity = 0
                    }
                    
                }
            }
        }
    }
    
    //Hide/Show seperator
    public var showSeperator:Bool = R.settings.seprator{
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
        }
    }
    
    //The background color of inner tabs when highlighted
    public var highlightedItemColor:UIColor = R.color.highlight
    
    //Enable or Disable the scroll view of the collection view
    public var isScrollEnabled:Bool = R.settings.scroll {
        didSet{
            if self.collectionView != nil {
                self.collectionView.isScrollEnabled = isScrollEnabled
            }
        }
    }
    
    public var isPagingEnabled:Bool = R.settings.page {
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
                NSLog("Error", "You must set the data source before attempting to change the index.")
            }
        }
    }
    
    /*
     * Private Properties
     */
    
    //The current page we are in
    private var currentPage:Int = 0
    
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
        
        self.collectionView.isPagingEnabled = false
        
        
        //Register AZTabBarItemCell
        self.collectionView.register(UINib(nibName: "AZTabBarItemCell", bundle: nil), forCellWithReuseIdentifier: AZTabBarItemCell.id())
        
        //Setup item amount
        self.itemAmount = self.dataSource.numberOfItemsInTabBar(self)
        
        //calculate pages needed, formula: case items is not divided by the amount of items per page, pages that are needed will be item amount divided by item per page + 1, else there won't be a +1.
        self.pageAmount =  itemAmount%itemPerPage != 0 ? (itemAmount - (itemAmount % itemPerPage)) / itemPerPage  + 1 : (itemAmount - (itemAmount % itemPerPage)) / itemPerPage
        
        //Setup functions (connection buttons to selectors, etc)
        initFunctionality()
        
        //Init design - colors,shapes...
        initUiDesign()
        
        //Set the page using the selected index
        switchTab(to: currentIndex)
        
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
                        self.selectedHiddenItem = self.currentIndex % self.itemPerPage != 0 ? self.currentIndex - (self.currentIndex % self.itemPerPage)  : self.currentIndex
                        self.currentPage = Int(self.selectedHiddenItem/self.itemPerPage)
                        
                        //Set the index as selected
                        self.collectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: false, scrollPosition: [])
                        
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
            self.switchTab(to: indexPath.item)
            
            //Highlight cell
            let cell = self.collectionView.cellForItem(at: indexPath) as! AZTabBarItemCell
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            cell.backgroundColor = highlightedItemColor
            
            //update current index
            self.currentIndex = indexPath.item
            
            //Call delegate methods
            self.delegate.stickerTabBar(self, didChangeToItem: currentIndex)
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
    
    
    
    /*
     * Private Methods
     */
    
    private func switchTab(to index:Int){
        
        //Remove any subviews from the container
        for view in self.viewContainer.subviews {
            view.removeFromSuperview()
        }
        
        //Add child view controller if found
        if let childController = self.dataSource.stickerTabBar(self, contentViewForPageAtIndex: index).controller {
            self.addChildViewController(childController)
        }
        
        //Init the view using the data source
        let view = self.dataSource.stickerTabBar(self, contentViewForPageAtIndex: index).contentView
        
        //Insert the container at the bottom
        self.viewContainer.insertSubview(view, at: 0)
        
        //setup layout constaints
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(self.viewContainer)
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
        
        //setup shadow - if enabled
        if allowSeperatorShadow {
            self.tabBarSeperatorLine.layer.masksToBounds = false
            self.tabBarSeperatorLine.layer.shadowOffset = CGSize(width:0,height: 0)
            self.tabBarSeperatorLine.layer.shadowRadius = R.ui.radius
            self.tabBarSeperatorLine.layer.shadowOpacity = R.ui.shadow
        }
        
        //setup seperator height
        if showSeperator {
            self.seperatorConstraint.constant = seperatorHeight
        }else{
            self.seperatorConstraint.constant = 0
        }
        
        
        //setup collection view design
        self.collectionView.backgroundColor = self.tabBackgroundColor
        
        //setup menu button design
        self.menuButton.setBackgroundImage(getImageWithColor(color: self.menuBackgroundColor, size: self.menuButton.bounds.size), for: [])
        self.menuButton.setBackgroundImage(getImageWithColor(color: self.menuBackgroundColor, size: self.menuButton.bounds.size), for: UIControlState.highlighted)
        self.menuButton.layer.cornerRadius = R.ui.radius
        self.menuButton.clipsToBounds = true
        self.menuButton.tintColor = menuIconColor
        
        
        //setup left/right arrow design
        self.leftScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: [])
        self.leftScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: UIControlState.highlighted)
        self.leftScrollButton.layer.cornerRadius = R.ui.radius 
        self.leftScrollButton.clipsToBounds = true
        
        self.rightScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: [])
        self.rightScrollButton.setBackgroundImage(getImageWithColor(color: self.arrowBackgroundColor, size: self.menuButton.bounds.size), for: UIControlState.highlighted)
        self.rightScrollButton.layer.cornerRadius = R.ui.radius
        self.rightScrollButton.clipsToBounds = true
        
        self.rightScrollButton.tintColor = arrowColor
        self.leftScrollButton.tintColor = arrowColor
        
        //Setup icons
        self.leftScrollButton.setImage(UIImage(named:R.assets.left), for: [])
        self.rightScrollButton.setImage(UIImage(named:R.assets.right), for: [])
        self.menuButton.setImage(UIImage(named:R.assets.menu), for: [])
        
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
            lockControlls(lock: true)
            
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
        self.delegate.stickerTabBar(self, didChangeToPage: currentPage)
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
        self.delegate.stickerTabBar(self, didChangeToPage: currentPage)
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
            self.delegate.stickerTabBar(self, didChangeToPage: currentPage)
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
            self.delegate.stickerTabBar(self, didChangeToPage: currentPage)
        }
        
    }
    
    public func clickMenu(sender: UIView){
        self.delegate.stickerTabBar(self, didSelectMenu: sender)
    }
    
    /*
     * Public Methods
     */
    
    public func selectedPage()->Int {
        return self.currentPage
    }
    
    public func reloadData(){
        collectionView.reloadData()
        initUiDesign()
    }
    
}












