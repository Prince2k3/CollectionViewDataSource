import UIKit

public protocol CollectionViewDataSourceDelegate {
    func didConfigure(_ cell: CollectionReusableViewDataSource, at indexPath: IndexPath)
}

public protocol CollectionReusableViewDataSource {
    func configure(_ item: Any?)
}

public struct CollectionReusableViewItem {
    public var identifier: String?
    public var item: Any?
}

open class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var reusableViewItems: [CollectionReusableViewItem]?
    private(set) var cellIdentifier: String?
    open var headerReusableViewItem: CollectionReusableViewItem?
    open var footerReusableViewItem: CollectionReusableViewItem?
    open var items: [Any]?
    open var title: String?
    open var delegate: CollectionViewDataSourceDelegate?
    open var cellMap: [String: String]?
    
    public convenience init(cellMap: [String: String], headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil, items: [Any]? = nil) {
        self.init()
        self.cellMap = cellMap
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
        self.items = items
    }
    
    public convenience init(cellIdentifier: String, headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil, items: [Any]? = nil) {
        self.init()
        self.cellIdentifier = cellIdentifier
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
        self.items = items
    }
    
    public convenience init(reusableViewItems: [CollectionReusableViewItem], headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil, items: [Any]? = nil) {
        self.init()
        self.reusableViewItems = reusableViewItems
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
        self.items = items
    }
    
    open func item(at indexPath: IndexPath) -> Any? {
        return items?[indexPath.row] ?? nil
    }
    
    open func cellIdentifier(at indexPath: IndexPath) -> String? {
        
        var identifier: String? = cellIdentifier
        if let cellMap = self.cellMap, let item = item(at: indexPath) {
            identifier = cellMap[NSStringFromClass(type(of: item) as! AnyClass)]
        }
        return identifier
    }
    
    //MARK - UICollectionViewDataSource 
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let reusableViewItems = reusableViewItems, reusableViewItems.count > 0 {
            return reusableViewItems.count
        }
        
        if let items = items {
            return items.count
        }
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier: String = ""
        var item: Any?
        
        if let cellMap = cellMap {
            item = self.item(at: indexPath)
            identifier = cellMap[NSStringFromClass(type(of: item!) as! AnyClass)]!
        } else if let reusableViewItems = reusableViewItems, reusableViewItems.count > 0 {
            let reusableViewItem: CollectionReusableViewItem = reusableViewItems[indexPath.row]
            identifier = reusableViewItem.identifier!
            item = reusableViewItem.item
        } else {
            item = self.item(at: indexPath)
            identifier = cellIdentifier!
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let sourceCell = cell as? CollectionReusableViewDataSource {
            sourceCell.configure(item)
            delegate?.didConfigure(sourceCell, at: indexPath)
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var identifier: String = ""
        var item: Any?
        
        if let headerReusableViewItem = headerReusableViewItem, kind == UICollectionElementKindSectionHeader {
            identifier = headerReusableViewItem.identifier!
            item = headerReusableViewItem.item
        } else if let footerReusableViewItem = footerReusableViewItem, kind == UICollectionElementKindSectionFooter {
            identifier = footerReusableViewItem.identifier!
            item = footerReusableViewItem.item
        }
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        
        if let sourceCell = cell as? CollectionReusableViewDataSource {
            sourceCell.configure(item)
            delegate?.didConfigure(sourceCell, at: indexPath)
        }
        
        return cell
    }
}

public class CollectionViewSectionDataSource: NSObject, UICollectionViewDataSource {
    
    public var delegate: CollectionViewDataSourceDelegate?
    public internal(set) var dataSources: [CollectionViewDataSource]?
    public var headerReusableViewItem: CollectionReusableViewItem?
    public var footerReusableViewItem: CollectionReusableViewItem?

    public convenience init(dataSources: [CollectionViewDataSource], headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil) {
        self.init()
        self.dataSources = dataSources
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
    }
    
    open func item(at indexPath: IndexPath) -> Any? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.item(at: indexPath)
    }
    
    open func dataSource(at indexPath: IndexPath) -> CollectionViewDataSource {
        return dataSources![indexPath.section]
    }
    
    open func title(forDataSourceAt indexPath: IndexPath) -> String? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.title
    }
    
    //MARK: - UICollectionViewDataSource
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let dataSources = dataSources {
            return dataSources.count
        }
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSources = self.dataSources {
            let dataSource = dataSources[section]
            return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}
