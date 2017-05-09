import UIKit

@objc(MSCollectionViewDataSourceDelegate)
public protocol CollectionViewDataSourceDelegate {
    @objc(dataSource:didConfigureCell:)
    func didConfigure(_ cell: CollectionReusableViewDataSource, at indexPath: IndexPath)
}

@objc(MSCollectionReusableViewDataSource)
public protocol CollectionReusableViewDataSource {
    @objc(configureItemForReusableView:)
    func configure(_ item: Any?)
}

@objc(MSCollectionReusableViewItem)
open class CollectionReusableViewItem: NSObject {
    open var identifier: String?
    open var item: Any?
}

@objc(MSCollectionViewDataSource)
open class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    fileprivate var reusableViewItems: [CollectionReusableViewItem]?
    fileprivate(set) var cellIdentifier: String?
    open var headerReusableViewItem: CollectionReusableViewItem?
    open var footerReusableViewItem: CollectionReusableViewItem?
    open var items: [Any]?
    open var title: String?
    open weak var delegate: CollectionViewDataSourceDelegate?
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
    
    @objc(itemAtIndexPath:)
    open func item(at indexPath: IndexPath) -> Any? {
        return items?[indexPath.row] ?? nil
    }
    
    @objc(cellIdentifierAtIndexPath:)
    open func cellIdentifier(at indexPath: IndexPath) -> String? {
        
        var identifier: String? = cellIdentifier
        if let cellMap = cellMap, let item = item(at: indexPath) {
            identifier = cellMap[NSStringFromClass(type(of: item) as! AnyClass)]
        }
        return identifier
    }
    
    //MARK - UICollectionViewDataSource 
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let reusableViewItems = reusableViewItems , reusableViewItems.count > 0 {
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
        } else if let reusableViewItems = reusableViewItems , reusableViewItems.count > 0 {
            let reusableViewItem: CollectionReusableViewItem = reusableViewItems[(indexPath as NSIndexPath).row]
            identifier = reusableViewItem.identifier!
            item = reusableViewItem.item
        } else {
            item = self.item(at: indexPath)
            identifier = cellIdentifier!
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if cell is CollectionReusableViewDataSource {
            let sourceCell = cell as! CollectionReusableViewDataSource
            sourceCell.configure(item)
            delegate?.didConfigure(sourceCell, at: indexPath)
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var identifier: String = ""
        var item: Any?
        
        if let headerReusableViewItem = headerReusableViewItem , kind == UICollectionElementKindSectionHeader {
            identifier = headerReusableViewItem.identifier!
            item = headerReusableViewItem.item
        } else if let footerReusableViewItem = footerReusableViewItem , kind == UICollectionElementKindSectionFooter {
            identifier = footerReusableViewItem.identifier!
            item = footerReusableViewItem.item
        }
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        
        if cell is CollectionReusableViewDataSource {
            let sourceCell = cell as! CollectionReusableViewDataSource
            sourceCell.configure(item)
            delegate?.didConfigure(sourceCell, at: indexPath)
        }
        
        return cell
    }
}

@objc(MSCollectionViewSectionDataSource)
open class CollectionViewSectionDataSource: NSObject, UICollectionViewDataSource {
    
    open var delegate: CollectionViewDataSourceDelegate?
    open fileprivate(set) var dataSources: [CollectionViewDataSource]?
    open var headerReusableViewItem: CollectionReusableViewItem?
    open var footerReusableViewItem: CollectionReusableViewItem?

    public convenience init(dataSources: [CollectionViewDataSource], headerReusableViewItem: CollectionReusableViewItem? = nil, footerReusableViewItem: CollectionReusableViewItem? = nil) {
        self.init()
        self.dataSources = dataSources
        self.headerReusableViewItem = headerReusableViewItem
        self.footerReusableViewItem = footerReusableViewItem
    }
    
    @objc(itemAtIndexPath:)
    func itemAt(indexPath: IndexPath) -> Any? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.item(at: indexPath)
    }
    
    @objc(dataSourceAtIndexPath:)
    func dataSource(at indexPath: IndexPath) -> CollectionViewDataSource {
        return dataSources![indexPath.section]
    }
    
    @objc(titleFromDataSourceAt:)
    func title(fromDataSourceAt indexPath: IndexPath) -> String? {
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
        if let dataSources = dataSources {
            let dataSource = dataSources[section]
            return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = dataSources![indexPath.section]
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dataSource = dataSources![indexPath.section]
        return dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}
