//
//  ViewController.swift
//  Sticker Tab Bar
//
//  Created by Antonio Zaitoun on 8/22/16.
//  Copyright © 2016 Crofis. All rights reserved.
//

import UIKit

class ViewController: UIViewController,AZTabBarDelegate,AZTabBarDataSource {

    
    //The line in the bottom of the navigation bar
    private var hairLine:UIImageView!
    var colors = [UIColor]()
    let size = 30

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Find and initalize the hairline
        for view in (self.navigationController?.navigationBar.subviews)! {
            for bView in view.subviews {
                if bView is UIImageView &&
                    bView.bounds.size.width == self.navigationController?.navigationBar.frame.size.width &&
                    bView.bounds.size.height < 2
                {
                    self.hairLine = bView as! UIImageView
                }
            }
        }
        
        for _ in 0...size  {
            colors.append(getRandomColor())
        }
        
        let controller = AZTabBarController.standardController()
        controller.delegate = self
        controller.dataSource = self
        controller.tabBackgroundColor = UIColor(red: (247.0 / 255.0), green: (247.0 / 255.0), blue: (247.0 / 255.0), alpha: 1)
        addChildViewController(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hairLine.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hairLine.isHidden = false
    }
    
    func numberOfItemsInTabBar(_ tabBarController: AZTabBarController) -> Int {
        return size
    }
    
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToItem index: Int) {
        print("Item Clicked: \(index+1)")
    }
    
    func stickerTabBar(_ tabBarController: AZTabBarController, didChangeToPage index: Int) {
        print("Current Page \(index+1)")
    }
    
    func stickerTabBar(_ tabBarController: AZTabBarController, didSelectMenu menu: UIView) {
        print("Menu Clicked")
    }
    
    func stickerTabBar(_ tabBarController: AZTabBarController, tabViewForPageAtIndex index: Int) -> UIView {
        
        let label = UILabel()
        label.text = "\(index+1)"
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.borderWidth = 0.2
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        
        return label
    }
    
    
    func stickerTabBar(_ tabBarController: AZTabBarController, contentViewForPageAtIndex index: Int) -> (contentView: UIView, controller: UIViewController?) {
        let view = UIView()
        view.backgroundColor = colors[index]
        return (view,nil)
    }
    
    private func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }


}



