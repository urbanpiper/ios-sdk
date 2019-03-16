//
//  SideMenuPanelDataModel.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 30/10/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import UIKit

@objc public protocol SideMenuPanelCellDelegate {
    func configureCell(_ sideMenuPanelTabDetail: SideMenuPanelTabDetail, extras: Extras?)
}

public class SideMenuPanelDataModel: UrbanPiperDataModel {
    
    public var hideLoginTab: Bool = false
    public var hideSettingsTabForGuestUser: Bool = false

    public var panelDetailArray: [SideMenuPanelTabDetail] {
        if UserManager.shared.currentUser != nil {
            return AppConfigManager.shared.loggedInUserSidePanelTabs.filter { $0.tag != Module.login }
        } else {
            var guestUserTabs = AppConfigManager.shared.guestUserSidePanelTabs
            
            if hideLoginTab {
                guestUserTabs = guestUserTabs.filter { $0.tag != Module.login }
            }
            
            let supportedLanguagesCount = Biz.shared?.supportedLanguages.count ?? 1
            if supportedLanguagesCount == 1 || hideSettingsTabForGuestUser {
                guestUserTabs = guestUserTabs.filter { $0.tag != Module.settings }
            }
            
            return guestUserTabs
        }
    }

    public func refreshSideMenu() {
        tableView?.reloadData()
        collectionView?.reloadData()
    }

    public func refreshData(_ isForcedRefresh: Bool = false) {
    }
}

//  MARK: UITableView DataSource
extension SideMenuPanelDataModel {

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return panelDetailArray.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier!, for: indexPath)

        if let menuCell: SideMenuPanelCellDelegate = cell as? SideMenuPanelCellDelegate {
            menuCell.configureCell(panelDetailArray[indexPath.row], extras: extras)
        } else {
            assert(false, "Cell does not conform to SideMenuPanelCellDelegate protocol")
        }

        return cell
    }
}

//  MARK: UICollectionView DataSource

extension SideMenuPanelDataModel {

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return panelDetailArray.count
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier!, for: indexPath)

        if let menuCell: SideMenuPanelCellDelegate = cell as? SideMenuPanelCellDelegate {
            menuCell.configureCell(panelDetailArray[indexPath.row], extras: extras)
        } else {
            assert(false, "Cell does not conform to SideMenuPanelCellDelegate protocol")
        }

        return cell
    }

}

//  App State Management

extension SideMenuPanelDataModel {

    @objc open override func appWillEnterForeground() {

    }

    @objc open override func appDidEnterBackground() {

    }

}

//  Reachability

extension SideMenuPanelDataModel {

    @objc open override func networkIsAvailable() {

    }

    @objc open override func networkIsDown() {

    }
}