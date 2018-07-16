//
//  FeaturedItemsDataModel.swift
//  UrbanPiperSDK
//
//  Created by Vid on 11/07/18.
//

import UIKit

@objc public protocol FeaturedItemsDataModelDelegate {
    
    func refreshFeaturedItemsUI(_ isRefreshing: Bool)
    
    func handleFeaturedItems(error: UPError?)
}


class FeaturedItemsDataModel: UrbanPiperDataModel {
    weak open var dataModelDelegate: FeaturedItemsDataModelDelegate?
    
    open var categoryItemsResponse: CategoryItemsResponse? {
        didSet {
            dataModelDelegate?.refreshFeaturedItemsUI(false)
            
            tableView?.reloadData()
            collectionView?.reloadData()
        }
    }
    
    open var itemsArray: [ItemObject]? {
        return categoryItemsResponse?.objects
    }
    
    open func refreshData(_ isForcedRefresh: Bool = false) {
        fetchFeaturedItems(isForcedRefresh: isForcedRefresh)
    }

}

//  MARK: API Calls

extension FeaturedItemsDataModel {
    
    fileprivate func fetchFeaturedItems(isForcedRefresh: Bool, next: String? = nil) {
        guard isForcedRefresh || (!isForcedRefresh && categoryItemsResponse == nil) else { return }
        dataModelDelegate?.refreshFeaturedItemsUI(true)
        let dataTask: URLSessionDataTask = APIManager.shared.featuredItems(locationID: OrderingStoreDataModel.shared.nearestStoreResponse?.store?.bizLocationId,
                                                                           next: next,
                                                                           completion: { [weak self] (data) in
                                                                            guard let response = data else { return }
                                                                            if next == nil {
                                                                                if response.objects.count > 1 {
                                                                                    response.objects.sort { (obj1, obj2) in
                                                                                        guard obj1.currentStock != 0 else { return false }
                                                                                        guard obj2.currentStock != 0 else { return true }
                                                                                        
                                                                                        return obj1.sortOrder < obj2.sortOrder
                                                                                    }
                                                                                }
                                                                                self?.categoryItemsResponse = response
                                                                            } else {
                                                                                let currentCategoriesItemsResponse = self?.categoryItemsResponse
                                                                                
                                                                                currentCategoriesItemsResponse?.objects.append(contentsOf: response.objects)
                                                                                currentCategoriesItemsResponse?.meta = response.meta
                                                                                
                                                                                currentCategoriesItemsResponse?.objects.sort { (obj1, obj2) in
                                                                                    guard obj1.currentStock != 0 else { return false }
                                                                                    guard obj2.currentStock != 0 else { return true }
                                                                                    
                                                                                    return obj1.sortOrder < obj2.sortOrder
                                                                                }
                                                                                
                                                                                self?.categoryItemsResponse = currentCategoriesItemsResponse
                                                                            }
            }, failure: { [weak self] (upError) in
                defer {
                    self?.dataModelDelegate?.handleFeaturedItems(error: upError)
                }
        })
        
        addOrCancelDataTask(dataTask: dataTask)
    }
}

//  MARK: UITableView DataSource
extension FeaturedItemsDataModel {
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemArrayCount = itemsArray?.count {
            return itemArrayCount
        } else {
            return 0
        }
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier!, for: indexPath)
        
        if let categoryCell: ItemCellDelegate = cell as? ItemCellDelegate {
            let itemObject: ItemObject = itemsArray![indexPath.row]
            if itemsArray?.last === itemObject, itemsArray!.count < categoryItemsResponse!.meta.totalCount {
                fetchFeaturedItems(isForcedRefresh: true, next: categoryItemsResponse?.meta.next)
            }
            categoryCell.configureCell(itemObject)
        } else {
            assert(false, "Cell does not conform to ItemCellDelegate protocol")
        }
        
        return cell
    }
    
}

//  MARK: UICollectionView DataSource

extension FeaturedItemsDataModel {
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray?.count ?? 0
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier!, for: indexPath)
        
        if let categoryCell: ItemCellDelegate = cell as? ItemCellDelegate {
            categoryCell.configureCell(itemsArray?[indexPath.row])
        } else {
            assert(false, "Cell does not conform to ItemCellDelegate protocol")
        }
        
        return cell
    }
    
}
