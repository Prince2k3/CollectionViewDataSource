//
//  TestCell.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class TestCell: UICollectionViewCell, CollectionReusableViewDataSource {
    static var identifier: String = "TestCell"
    
    func configure(_ item: Any?) {
        self.backgroundColor = UIColor.red
    }
}
