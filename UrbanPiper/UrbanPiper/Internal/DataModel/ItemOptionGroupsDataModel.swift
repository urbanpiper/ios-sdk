//
//  ItemOptionGroupsDataModel.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 19/12/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import UIKit

@objc public protocol ItemOptionGroupsCellDelegate {
    func configureCell(_ itemOptionGroup: ItemOptionGroup?, extras: Extras?)
}

public class ItemOptionGroupsDataModel: UrbanPiperDataModel {
    
    var itemOptionGroupsArray: [ItemOptionGroup]?

    public func refreshSideMenu() {
        tableView?.reloadData()
        collectionView?.reloadData()
    }

    public func refreshData(_ isForcedRefresh: Bool = false) {
    }
}

//  MARK: UITableView DataSource
extension ItemOptionGroupsDataModel {

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemOptionGroupsArray?.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier!, for: indexPath)

        if let menuCell: ItemOptionGroupsCellDelegate = cell as? ItemOptionGroupsCellDelegate {
            menuCell.configureCell(itemOptionGroupsArray?[indexPath.row], extras: extras)
        } else {
            assert(false, "Cell does not conform to ItemOptionGroupsCellDelegate protocol")
        }

        return cell
    }
}

//  MARK: UICollectionView DataSource

extension ItemOptionGroupsDataModel {

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemOptionGroupsArray?.count ?? 0
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier!, for: indexPath)

        if let menuCell: ItemOptionGroupsCellDelegate = cell as? ItemOptionGroupsCellDelegate {
            menuCell.configureCell(itemOptionGroupsArray?[indexPath.row], extras: extras)
        } else {
            assert(false, "Cell does not conform to ItemOptionGroupsCellDelegate protocol")
        }

        return cell
    }

}

//  App State Management

extension ItemOptionGroupsDataModel {

    @objc open override func appWillEnterForeground() {

    }

    @objc open override func appDidEnterBackground() {

    }

}

//  Reachability

extension ItemOptionGroupsDataModel {

    @objc open override func networkIsAvailable() {

    }

    @objc open override func networkIsDown() {

    }
}