//
//  ItemDetailsDataModel.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 30/10/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import UIKit


@objc public protocol ItemDetailsDataModelDelegate {

    func refreshItemDetailsUI()
    func handleItemDetails(error: UPError?)

}

public class ItemDetailsDataModel: UrbanPiperDataModel {

    weak public var dataModelDelegate: ItemDetailsDataModelDelegate?

    public var itemId: Int? {
        didSet {
            refreshData()
        }
    }

    public var item: Item?
    public var userLikesResponse: UserLikesResponse?

    private override init() {
        super.init()
    }

    public convenience init(delegate: ItemDetailsDataModelDelegate) {
        self.init()

        dataModelDelegate = delegate
        
        refreshData()
    }

    public func refreshData(_ isForcedRefresh: Bool = false) {
        fetchItemLikes()

        guard let id = itemId else {
            dataModelDelegate?.handleItemDetails(error: nil)
            return
        }

        fetchItemDetails(itemId: id)
    }

}

//  MARK: API Calls

extension ItemDetailsDataModel {

    fileprivate func fetchItemLikes() {
        guard UserManager.shared.currentUser != nil else { return }

        let dataTask: URLSessionDataTask = APIManager.shared.userLikes(completion: { [weak self] (data) in
            defer {
                self?.dataModelDelegate?.refreshItemDetailsUI()
            }
            guard let response = data else { return }
            self?.userLikesResponse = response
            }, failure: { [weak self] (upError) in
                defer {
                    self?.dataModelDelegate?.handleItemDetails(error: upError)
                }
        })

        addDataTask(dataTask: dataTask)
    }

    public func likeUnlikeItem(like: Bool) {
        guard let itemDetails = item, let userLikes = userLikesResponse else { return }
        if like {
            let dataTask: URLSessionDataTask = APIManager.shared.likeItem(itemId: itemDetails.id,
                                                                          completion:
                { [weak self] (data) in
                    if let likeCount = self?.item?.likes {
                        if like {
                            self?.item?.likes = likeCount + 1
                            AnalyticsManager.shared.track(event: .itemLiked(itemTitle: itemDetails.itemTitle))
                        } else {
                            self?.item?.likes = likeCount - 1
                            AnalyticsManager.shared.track(event: .itemUnliked(itemTitle: itemDetails.itemTitle))
                        }
                    }
                    self?.fetchItemLikes()
                }, failure: { [weak self] (upError) in
                    defer {
                        self?.dataModelDelegate?.refreshItemDetailsUI()
                        self?.dataModelDelegate?.handleItemDetails(error: upError)
                    }
            })
            addDataTask(dataTask: dataTask)
        } else {
            let dataTask: URLSessionDataTask = APIManager.shared.unlikeItem(itemId: itemDetails.id,
                                                                                completion:
                { [weak self] (data) in
                    if let likeCount = self?.item?.likes {
                        if like {
                            self?.item?.likes = likeCount + 1
                            AnalyticsManager.shared.track(event: .itemLiked(itemTitle: itemDetails.itemTitle))
                        } else {
                            self?.item?.likes = likeCount - 1
                            AnalyticsManager.shared.track(event: .itemUnliked(itemTitle: itemDetails.itemTitle))
                        }
                    }
                    self?.fetchItemLikes()
                }, failure: { [weak self] (upError) in
                    defer {
                        self?.dataModelDelegate?.refreshItemDetailsUI()
                        self?.dataModelDelegate?.handleItemDetails(error: upError)
                    }
            })
            addDataTask(dataTask: dataTask)
        }        
    }

    fileprivate func fetchItemDetails(itemId: Int)  {
        let dataTask: URLSessionDataTask = APIManager.shared.getItemDetails(itemId: itemId,
                                                          storeId: OrderingStoreDataModel.shared.orderingStore?.bizLocationId,
                                                          completion: { [weak self] (data) in
            defer {
                self?.dataModelDelegate?.refreshItemDetailsUI()
            }
            guard let response = data else { return }
            if self?.item != nil {
                self?.item?.update(fromDictionary: response.toDictionary())
            } else {
                self?.item = response
            }
        }, failure: { [weak self] (upError) in
            defer {
                self?.dataModelDelegate?.handleItemDetails(error: upError)
            }
        })

        addDataTask(dataTask: dataTask)
    }

}

//  App State Management

extension ItemDetailsDataModel {

    open override func appWillEnterForeground() {
        refreshData()
    }

    @objc open override func appDidEnterBackground() {

    }

}

//  Reachability

extension ItemDetailsDataModel {

    open override func networkIsAvailable() {
        refreshData()
    }

}