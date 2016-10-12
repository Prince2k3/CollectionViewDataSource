//
//  ViewController.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sampleData: [String] = ["Bananas", "Apples", "Oranges", "Grapes", "Strawberry", "Pineapple", "Mango"]
    var dataSource: CollectionViewDataSource = CollectionViewDataSource(cellIdentifier:  TestCell.identifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.identifier)
        
        self.dataSource.items = self.sampleData
        self.collectionView.dataSource = self.dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

