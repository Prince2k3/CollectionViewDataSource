import UIKit

public protocol CollectionViewDataSourceDelegate {
    func didConfigure(cell: CollectionReusableViewDataSource, atIndexPath indexPath: NSIndexPath)
}

public protocol CollectionReusableViewDataSource {
    func configure(item: AnyObject?)
}

public struct CollectionReusableViewItem {
    var identifier: String?
    var item: AnyObject?
}

public class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var reusableViewItems: [CollectionReusableViewItem]?
    private(set) var cellIdentifier: String?
    public var headerReusableViewItem: CollectionReusableViewItem?
    public var footerReusableViewItem: CollectionReusableViewItem?
    public var items: [AnyObject]?
    public var title: String?
    public var delegate: CollectionViewDataSourceDelegate?
    public var cellMap: [String: String]?
    
    public convenience init(cellMap: [String: String], headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil, items: [AnyObject]? = nil) {
        self.init()
        self.cellMap = cellMap
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
        self.items = items
    }
    
    public convenience init(cellIdentifier: String, headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil, items: [AnyObject]? = nil) {
        self.init()
        self.cellIdentifier = cellIdentifier
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
        self.items = items
    }
    
    public convenience init(reusableViewItems: [CollectionReusableViewItem], headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil, items: [AnyObject]? = nil) {
        self.init()
        self.reusableViewItems = reusableViewItems
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
        self.items = items
    }
    
    public func itemAt(indexPath: NSIndexPath) -> AnyObject? {
        return items?[indexPath.row] ?? nil
    }
    
    public func cellIdentifierAt(indexPath: NSIndexPath) -> String? {
        
        var identifier: String? = cellIdentifier
        if let cellMap = cellMap, item: AnyObject = itemAt(indexPath) {
            identifier = cellMap[NSStringFromClass(item.dynamicType)]
        }
        return identifier
    }
    
    //MARK - UICollectionViewDataSource 
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let reusableViewItems = reusableViewItems where reusableViewItems.count > 0 {
            return reusableViewItems.count
        }
        
        if let items = items {
            return items.count
        }
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var identifier: String = ""
        var item: AnyObject?
        
        if let cellMap = cellMap {
            item = itemAt(indexPath)
            identifier = cellMap[NSStringFromClass(item!.dynamicType)]!
        } else if let reusableViewItems = reusableViewItems where reusableViewItems.count > 0 {
            let reusableViewItem: CollectionReusableViewItem = reusableViewItems[indexPath.row]
            identifier = reusableViewItem.identifier!
            item = reusableViewItem.item
        } else {
            item = itemAt(indexPath)
            identifier = cellIdentifier!
        }
        
        let cell: CollectionReusableViewDataSource = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CollectionReusableViewDataSource
        cell.configure(item)
        delegate?.didConfigure(cell, atIndexPath: indexPath)
        return (cell as? UICollectionViewCell)!
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var identifier: String = ""
        var item: AnyObject?
        
        if let headerReusableViewItem = headerReusableViewItem where kind == UICollectionElementKindSectionHeader {
            identifier = headerReusableViewItem.identifier!
            item = headerReusableViewItem.item
        } else if let footerReusableViewItem = footerReusableViewItem where kind == UICollectionElementKindSectionFooter {
            identifier = footerReusableViewItem.identifier!
            item = footerReusableViewItem.item
        }
        
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath)
        
        if cell is CollectionReusableViewDataSource {
            let sourceCell = cell as! CollectionReusableViewDataSource
            sourceCell.configure(item)
            delegate?.didConfigure(sourceCell, atIndexPath: indexPath)
        }
        
        return cell
    }
}

public class CollectionViewSectionDataSource: NSObject, UICollectionViewDataSource {
    
    public var delegate: CollectionViewDataSourceDelegate?
    public private(set) var dataSources: [CollectionViewDataSource]?
    public var headerReusableViewItem: CollectionReusableViewItem?
    public var footerReusableViewItem: CollectionReusableViewItem?

    public convenience init(dataSources: [CollectionViewDataSource], headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil) {
        self.init()
        self.dataSources = dataSources
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
    }
    
    func itemAt(indexPath: NSIndexPath) -> AnyObject? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.itemAt(indexPath)
    }
    
    func dataSourceAt(indexPath: NSIndexPath) -> CollectionViewDataSource {
        return dataSources![indexPath.section]
    }
    
    func titleForDataSourceAt(indexPath: NSIndexPath) -> String? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.title
    }
    
    //MARK: - UICollectionViewDataSource
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let dataSources = dataSources {
            return dataSources.count
        }
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSources = dataSources {
            let dataSource = dataSources[section]
            return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let dataSource = dataSources![indexPath.section]
        return dataSource.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let dataSource = dataSources![indexPath.section]
        return dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
}
