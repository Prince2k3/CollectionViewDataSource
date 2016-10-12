//
//  ViewController3.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController3: UIViewController, CollectionViewDataSourceDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sectionDataSource: CollectionViewSectionDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.identifier)
        
        build()
    }
    
    func build() {
        var dataSources = [CollectionViewDataSource]()
        
        for i in 0..<3 {
            
            var items = [Int]()
            for j in 0..<10 {
                items.append(j)
            }
            
            let dataSource = CollectionViewDataSource(cellIdentifier: TestCell.identifier, items: items)
            dataSource.title = "Section \(i)"
            
            dataSources.append(dataSource)
        }
        
        
        self.sectionDataSource = CollectionViewSectionDataSource(dataSources: dataSources)
        self.sectionDataSource?.delegate = self
        self.collectionView.dataSource = self.sectionDataSource
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didConfigure(_ cell: CollectionReusableViewDataSource, at indexPath: IndexPath) {
        
    }
}
