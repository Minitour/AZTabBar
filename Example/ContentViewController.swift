//
//  ContentViewController.swift
//  Example
//
//  Created by Antonio Zaitoun on 8/25/16.
//  Copyright © 2016 New Sound Interactive. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController:UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    
    
    public var backgroundColor:UIColor!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = self.backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/3, height: self.collectionView.frame.size.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 34
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCell", for: indexPath) as! DemoCell
        cell.demoImage.image = nil
        cell.demoImage.image = UIImage(named: "demo_1")
        cell.demoImage.contentMode = .scaleAspectFit
        
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.contentOffset.y = 0
    }
    
}

class DemoCell:UICollectionViewCell{

    @IBOutlet weak var demoImage:UIImageView!
}
