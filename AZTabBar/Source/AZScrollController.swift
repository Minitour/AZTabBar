//
//  AZScrollController.swift
//  Example
//
//  Created by Antonio Zaitoun on 8/30/16.
//  Copyright © 2016 New Sound Interactive. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class AZScrollController: UIViewController {
    
    class func standardController()->AZScrollController{
        return UIStoryboard(name: AZTabBar.R.xib.storyboard, bundle: Bundle(for: self)).instantiateViewController(withIdentifier: AZTabBar.R.xib.scrollController) as! AZScrollController
    }
    
    /*
     * Outsider Views
     */
    
    //The tab bar
    @IBOutlet weak var tabBar: UIView!
    
    //The line (view) under the tab bar
    @IBOutlet weak var tabBarSeperatorLine: UIView!
    
    //The container that holdes the content
    @IBOutlet weak var viewContainer: UICollectionView!
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    
    
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
    public var delegate:AZScrollDelegate!
    
    //The data source
    public var dataSource:AZScrollDataSource!
    
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
    public var seperatorHeight:CGFloat = 0 {
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
    public var allowSeperatorShadow:Bool = false/*AZTabBar.R.settings.shadow*/{
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
    
    //Enable or disable the paging for the tab bar items
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
                if self.currentIndex >= self.dataSource.numberOfTabs(self){
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
    
    public var tabBarHeight:CGFloat = AZTabBar.R.ui.scrollerTabBarHeight {
        didSet{
            if tabBarHeightConstraint != nil {
                if tabBarHeightConstraint.constant != tabBarHeight {
                    self.tabBarHeightConstraint.constant = tabBarHeight
                }
            }
        }
    }
    
    /*
     * Internal Properties - These properties are internal because the extenstions make use of them. If there were no extenstions these would be private.
     */
    
    //This index points to the first item of the current page
    internal var selectedHiddenItem = 0
    
    //The amount of items that the collectionview holds
    internal var itemAmount:Int = 0
    
    //The number of pages that are needed to display the items
    internal var pageAmount:Int = 0
    
    //global flag, Do no change - used to check if the index was highlighted (starting index)
    internal var didInitHighlight = false
    
    //stored offset - to track if we move up or down
    internal var lastContentOffset: CGFloat = 0
    
    //The current page we are in
    internal var currentPage:Int = 0 {
        didSet{
            
            if currentPage != oldValue {
                
            }
        }
    }
    
    //A flag that indicates if the tab bar is being animated
    internal var isAnimatingTabBar = false
    
    //A flag that indicates if the tab bar is visable or not
    internal var isBarHidden = false
    
    //The current orientation
    internal var orientation:UICellOrientation = .portrait
    
    //A flag that indicates that the device is in mid orientation change
    internal var isRotating = false
    
    //The origin of the tab bar
    internal var tabBarOrigin:CGPoint!
    
    /*
     * Private Properties
     */
    
    //Track menu animations to disable interaction when needed
    private var isMenuViewAnimating = false {
        didSet{
            menuButton.isUserInteractionEnabled = !isMenuViewAnimating
            menuDismissButton.isUserInteractionEnabled = !isMenuViewAnimating
        }
    }
    
    //global flag, set to true once viewDidLoad has finished.
    private var didInit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogic()
        
        setupInterface()
        
        switchTab(to: currentIndex, from: -1)
        
        didInit = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let insets = UIEdgeInsets(top: self.tabBarHeight, left: 0, bottom: 0, right: 0)
        self.viewContainer.contentInset = insets
        
        self.viewContainer.scrollIndicatorInsets = insets
        
        self.tabBarOrigin = self.tabBar.frame.origin

    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.isRotating = true
        self.tabBar.translatesAutoresizingMaskIntoConstraints = false
        //Method is called when orientation is changed
        if UIDevice.current.orientation.isLandscape {
            self.orientation = .landscape
        } else {
            self.orientation = .portrait
        }
        //Once screen size has changed -> wait for animation to finish.
        coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
            }, completion: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                
                //Reload data -> to recalculate the sizes of the cells
                self.collectionView.performBatchUpdates({
                    //On completion -> reload that data and reselect the selected index (highlight it)
                    self.collectionView.reloadData()
                    
                    }, completion: { (Bool) in
                        
                        
                        //Set the index as selected
                        self.collectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: true, scrollPosition: [])
                        
                        //Init the cell
                        let cell = self.collectionView.cellForItem(at: IndexPath(item: self.currentIndex, section: 0))
                        
                        //Set the cell as selected
                        cell?.isSelected = true
                        
                        //Scroll to the selected section (because when reloading we will be at the first index) with no animation
                        self.collectionView.scrollToItem(at: IndexPath(item: self.selectedHiddenItem, section: 0), at: .left, animated: true)
                        
                        
                        
                })
                self.viewContainer.performBatchUpdates({
                    self.viewContainer.reloadData()
                    }, completion: { (Bool) in
                        self.viewContainer.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: [], animated: false)
                        self.isRotating = false
                })
                
                self.tabBarOrigin = self.tabBar.frame.origin
                
        })
    }
    
    func setupInterface(){
        
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
    
    func setupLogic(){
        
        //Disable multi selection
        self.collectionView.allowsMultipleSelection = false
        
        //Enable selection
        self.collectionView.allowsSelection = true
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.viewContainer.delegate = self
        self.viewContainer.dataSource = self
        
        self.viewContainer.showsVerticalScrollIndicator = false
        
        self.viewContainer.showsHorizontalScrollIndicator = false
        
        //Register AZTabBarItemCell
        self.collectionView.register(UINib(nibName: AZTabBar.R.xib.flex, bundle: nil), forCellWithReuseIdentifier: AZFlexableCell.id())
        
        //Register AZTabBarItemCell
        self.viewContainer.register(UINib(nibName: AZTabBar.R.xib.flex, bundle: nil), forCellWithReuseIdentifier: AZFlexableCell.id())
        
        self.itemAmount = self.dataSource.numberOfTabs(self)
        
        let itemPerPage = self.itemPerPage()
        self.pageAmount =  itemAmount % itemPerPage != 0 ? (itemAmount - (itemAmount % itemPerPage)) / itemPerPage  + 1 : (itemAmount - (itemAmount % itemPerPage)) / itemPerPage
        
        //Add targets to buttons
        self.leftScrollButton.addTarget(self, action: #selector(AZScrollController.scrollLeft(sender:)), for: .touchUpInside)
        self.rightScrollButton.addTarget(self, action: #selector(AZScrollController.scrollRight(sender:)), for: .touchUpInside)
        
        var longClickGesture = UILongPressGestureRecognizer(target: self, action: #selector(AZScrollController.fullScrollLeft(sender:)))
        self.leftScrollButton.addGestureRecognizer(longClickGesture)
        longClickGesture = UILongPressGestureRecognizer(target: self, action: #selector(AZScrollController.fullScrollRight(sender:)))
        self.rightScrollButton.addGestureRecognizer(longClickGesture)
        
        self.menuButton.addTarget(self, action: #selector(AZTabBarController.clickMenu(sender:)), for: .touchUpInside)
        
        self.menuDismissButton.addTarget(self, action: #selector(AZScrollController.clickDismissMenu(sender:)), for: .touchUpInside)
        
        self.leftScrollButton.isExclusiveTouch = true
        self.rightScrollButton.isExclusiveTouch = true
        self.menuButton.isExclusiveTouch = true
        
        
        
    }
    
    internal func switchTab(to index:Int,from oldIndex:Int){
        
        //scroll to tab
        
        
        self.viewContainer.setContentOffset(CGPoint(x: 0, y: self.calculateCellOffsets()[index]), animated: true)
        
        switchMenuView(to: index)
        
    }
    
    internal func switchMenuView(to index: Int){
        //init custom menu view
        if self.isCustomMenuEnabled {
            
            for view in self.customMenuView.subviews {
                view.removeFromSuperview()
            }
            
            if let subView = self.dataSource.scrollableTab(self, menuViewForIndexAt: index) {
                self.customMenuView.addSubview(subView)
                
                subView.snp_makeConstraints(closure: { (make) in
                    make.edges.equalTo(self.customMenuView)
                })
            }
            
            if let image = self.dataSource.scrollableTab(self, imageForMenuAt: index){
                self.customMenuIcon.isHidden = false
                self.customMenuIcon.image = image
            }else{
                self.customMenuIcon.isHidden = true
                self.customMenuIcon.image = nil
            }
            
            if let title = self.dataSource.scrollableTab(self, titleForMenuAt: index) {
                self.customMenuTitle.isHidden = false
                self.customMenuTitle.text = title
            }else{
                self.customMenuTitle.isHidden = true
                self.customMenuTitle.text = ""
            }
        }
    }
    
    internal func calculateCellOffsets()->[CGFloat]{
        
        var offsets = [CGFloat](repeating: 0.0,count: self.dataSource.numberOfTabs(self) + 1)
        for index in 1...self.dataSource.numberOfTabs(self) {
            let cellHeight = self.dataSource.scrollableTab(self, contentSizeForIndexAt: index-1, for: self.orientation)
            offsets[index] = offsets[index-1] + cellHeight
        }
        
        return offsets
    }
    
    internal func offsetInRange(currentOffset:CGFloat, offsets:[CGFloat]) ->Int {
        for index in 0...offsets.count - 2 {
            if currentOffset <= offsets[index+1] && currentOffset >= offsets[index] {
                return index
            }
        }
        return 0
    }
    
    internal func itemPerPage()->Int {
        return self.dataSource.scrollableTab(self, numberOfTabsPerPageFor: self.orientation)
    }
    
    func lockControlls(lock:Bool){
        //enable/disable interaction with buttons
        self.leftScrollButton.isUserInteractionEnabled = !lock
        self.rightScrollButton.isUserInteractionEnabled = !lock
    }
    
    func scrollLeft(sender:AnyObject){
        
        let itemPerPage = self.itemPerPage()
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
    
    func scrollRight(sender:AnyObject){
        
        //increase by 'itemPerPage'
        let itemPerPage = self.itemPerPage()
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
    
    func fullScrollLeft(sender:AnyObject){
        
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
    
    func fullScrollRight(sender:AnyObject){
        
        //Selected hidden item = the first index in the last page
        
        let itemPerPage = self.itemPerPage()
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
        self.delegate.scrollableTab(self, didSelectMenuAt: currentIndex)
        if isCustomMenuEnabled {setMenu(hidden: false, animated: true)}
        
    }
    
    public func clickDismissMenu(sender: UIView){
        self.delegate.scrollableTab(self, didDismissMenuAt: currentIndex)
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
    
    private func scroll(to index:Int,animated:Bool){
        //Assert index
        if index >= 0 && index < self.itemAmount {
            //lock controls before scroll
            //lockControlls(lock: true)
            
            //Scroll to index
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: animated)
        }
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
        setupInterface()
    }
}


extension AZScrollController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1 {
            if !isRotating {

                

                if scrollView.contentOffset.y >= scrollView.contentInset.top && scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.frame.height{
                    if (self.lastContentOffset > scrollView.contentOffset.y) {
                        // move up
                        
                        if isBarHidden {
                            if !isAnimatingTabBar {
                                isAnimatingTabBar = true
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.tabBar.frame = CGRect(origin: self.tabBarOrigin, size: self.tabBar.frame.size)
                                    }, completion: { (Bool) in
                                        self.isAnimatingTabBar = false
                                        self.isBarHidden = false
                                })
                            }
                        }
                    }
                    else if (self.lastContentOffset < scrollView.contentOffset.y) {
                        // move down
                        if !isBarHidden{
                            if !isAnimatingTabBar {
                                if !isAnimatingTabBar {
                                    isAnimatingTabBar = true
                                    self.tabBar.translatesAutoresizingMaskIntoConstraints = true
                                    UIView.animate(withDuration: 0.5, animations: {
                                        let frame = CGRect(origin: CGPoint(x: self.tabBarOrigin.x, y: -self.tabBarOrigin.y), size: self.tabBar.frame.size)
                                        self.tabBar.frame = frame
                                        }, completion: { (Bool) in
                                            self.isAnimatingTabBar = false
                                            self.isBarHidden = true
                                            
                                    })
                                }
                            }
                        }
                        
                    }
                    // update the new position acquired
                    self.lastContentOffset = scrollView.contentOffset.y
                }
                else{
                    if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.height{
                        
                    }else{
                        if isBarHidden {
                            isAnimatingTabBar = true
                            UIView.animate(withDuration: 0.5, animations: {
                                self.tabBar.frame = CGRect(origin: self.tabBarOrigin, size: self.tabBar.frame.size)
                                }, completion: { (Bool) in
                                    self.isAnimatingTabBar = false
                                    self.isBarHidden = false
                                    
                            })
                        }
                    }
                    
                }
                
                let newIndex = offsetInRange(currentOffset: scrollView.contentOffset.y + scrollView.frame.height/2, offsets: self.calculateCellOffsets())
                if self.currentIndex != newIndex {
                    
                    //un highlight cell
                    if let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex,section: 0)){
                        cell.backgroundColor = UIColor.clear
                        cell.isSelected = false
                        collectionView.deselectItem(at: IndexPath(item: currentIndex,section: 0), animated: false)
                    }
                    
                    self.currentIndex = newIndex
                    
                    collectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: false, scrollPosition: [])
                    if let cell = collectionView.cellForItem(at: IndexPath(item: self.currentIndex,section: 0)){
                        cell.backgroundColor = self.highlightedItemColor
                        cell.isSelected = true
                    }
                    
                    self.switchMenuView(to: currentIndex)
                    
                    delegate.scrollableTab(self, didSelectIndexAt: currentIndex)
                    
                }
                
                let itemPerPage = self.itemPerPage()
                let page = self.currentIndex % itemPerPage != 0 ? self.currentIndex - (self.currentIndex % itemPerPage)  : self.currentIndex
                if self.currentPage != page{
                    self.currentPage = page
                    
                    self.collectionView.scrollToItem(at: IndexPath(item: page,section: 0), at: .left, animated: true)
                }
            }
        }
    }
    
    
}

extension AZScrollController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag{
        case 0:
            let itemPerPage = self.itemPerPage()
            return CGSize(width: collectionView.frame.width/CGFloat(itemPerPage), height: collectionView.frame.height)
        case 1:
            return CGSize(width: collectionView.frame.width, height: self.dataSource.scrollableTab(self, contentSizeForIndexAt: indexPath.item, for: self.orientation))
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 0:
            //Check if cell was not already selected
            if indexPath.item != currentIndex {
                
                //Switch container view
                
                self.switchTab(to: indexPath.item,from: currentIndex)
                
                //Highlight cell
                let cell = collectionView.cellForItem(at: indexPath) as! AZFlexableCell
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                cell.backgroundColor = highlightedItemColor
                
                //update current index
                self.currentIndex = indexPath.item
                
                //Call delegate methods
                self.delegate.scrollableTab(self, didSelectIndexAt: indexPath.item)
            }
            break
        case 1:
            
            break
        default:
            break
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //Change un-highlight the cell that was deselected
        switch collectionView.tag {
        case 0:
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isSelected = false
            cell?.backgroundColor = UIColor.clear
            break
            
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 0:
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
                let itemPerPage = self.itemPerPage()
                self.selectedHiddenItem = itemAmount % itemPerPage == 0 ? itemAmount - (itemAmount % itemPerPage) - itemPerPage :  itemAmount - (itemAmount % itemPerPage)
                rightScrollButton.isEnabled = false
            }
            break
        default:
            break
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 0:
            if indexPath.item == 0 {
                leftScrollButton.isEnabled = true
            }
            
            //Update rightScrollButton case the right edge is not showing
            if indexPath.item == itemAmount - 1 {
                rightScrollButton.isEnabled = true
            }
            break
        default:
            break
        }
        
    }
    
    
}

extension AZScrollController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            //Dequeue cell
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: AZFlexableCell.id(), for: indexPath) as! AZFlexableCell
            
            //Reset cell - remove all subviews from itemViewHolder
            for view in itemCell.itemViewHolder.subviews {
                view.removeFromSuperview()
            }
            
            //Init a view from the dataSource
            let view = self.dataSource.scrollableTab(self, tabViewForIndexAt: indexPath.item)
            
            //Add the view
            itemCell.itemViewHolder.addSubview(view)
            
            //Setup autolayout - Uses SnapKit to to match the subview to the item view holder
            view.snp_makeConstraints { (make) in
                make.edges.equalTo(itemCell.itemViewHolder)
            }
            
            //Highlight cell if selected
            if self.didInitHighlight == false && indexPath.item == currentIndex {
                
                //Scroll to cell (if needed)
                collectionView.scrollToItem(at: IndexPath(item: self.selectedHiddenItem, section: 0), at: .left, animated: false)
                
                //select cell
                collectionView.selectItem(at: IndexPath(item: self.currentIndex, section: 0), animated: false, scrollPosition: [])
                
                //set cell as selected
                itemCell.isSelected = true
                
                //Disable flag
                self.didInitHighlight = true
            }
            
            //Highlight cell if it is selected
            if indexPath.item == currentIndex {
                itemCell.backgroundColor = highlightedItemColor
            }else{
                itemCell.backgroundColor = UIColor.clear
            }
            
            
            
            return itemCell
        case 1:
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: AZFlexableCell.id(), for: indexPath) as! AZFlexableCell
            
            //Reset cell - remove all subviews from itemViewHolder
            for view in itemCell.itemViewHolder.subviews {
                view.removeFromSuperview()
            }
            
            //Init a view from the dataSource
            let view = self.dataSource.scrollableTab(self, contentViewForIndexAt: indexPath.item)
            
            //Add the view
            itemCell.itemViewHolder.addSubview(view)
            
            //Setup autolayout - Uses SnapKit to to match the subview to the item view holder
            view.snp_makeConstraints { (make) in
                make.edges.equalTo(itemCell.itemViewHolder)
            }
            return itemCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.numberOfTabs(self)
    }
    
}

protocol AZScrollDelegate {
    
    func scrollableTab(_ scrollable: AZScrollController, didSelectIndexAt index: Int)
    
    func scrollableTab(_ scrollable: AZScrollController, didSelectMenuAt index: Int)
    
    func scrollableTab(_ scrollable: AZScrollController, didDismissMenuAt index: Int)
}

protocol AZScrollDataSource {
    
    func numberOfTabs(_ scrollable: AZScrollController)-> Int
    
    func scrollableTab(_ scrollable: AZScrollController, numberOfTabsPerPageFor orientation:UICellOrientation) -> Int
    
    func scrollableTab(_ scrollable: AZScrollController, contentSizeForIndexAt index:Int, for orientation:UICellOrientation) -> CGFloat
    
    func scrollableTab(_ scrollable: AZScrollController, tabViewForIndexAt index:Int) -> UIView
    
    func scrollableTab(_ scrollable: AZScrollController, contentViewForIndexAt index:Int) -> UIView
    
    func scrollableTab(_ scrollable: AZScrollController, menuViewForIndexAt index:Int) -> UIView?
    
    func scrollableTab(_ scrollable: AZScrollController, titleForMenuAt index:Int) -> String?
    
    func scrollableTab(_ scrollable: AZScrollController, imageForMenuAt index:Int) -> UIImage?
}

enum UICellOrientation {
    case portrait
    case landscape
}










