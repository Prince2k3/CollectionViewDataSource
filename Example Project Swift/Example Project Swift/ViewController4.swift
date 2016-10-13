//
//  ViewController4.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController4: UIViewController, CollectionViewDataSourceDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: CollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: TestTextFieldCell.identifier, bundle: nil), forCellWithReuseIdentifier: TestTextFieldCell.identifier)
        
        build()
    }
    
    func build() {
        
        let item = CollectionReusableViewItem()
        item.identifier = TestTextFieldCell.identifier
        
        self.dataSource = CollectionViewDataSource(reusableViewItems: [item])
        self.dataSource?.delegate = self
        self.collectionView?.dataSource = self.dataSource
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didConfigure(_ cell: CollectionReusableViewDataSource, at indexPath: IndexPath) {
        let textFieldCell = cell as? TestTextFieldCell
        textFieldCell?.valueDidChange = { text in
            print(text)
        }
    }
}
