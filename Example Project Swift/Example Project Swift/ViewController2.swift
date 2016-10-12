//
//  SecondViewController.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: CollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.identifier)
        
        build()
    }

    func build() {
        var items = [CollectionReusableViewItem]()
        for _ in 0..<100 {
            var cellItem = CollectionReusableViewItem()
            cellItem.identifier = TestCell.identifier
            items.append(cellItem)
        }
        self.dataSource = CollectionViewDataSource(reusableViewItems: items)
        self.collectionView.dataSource = self.dataSource
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

