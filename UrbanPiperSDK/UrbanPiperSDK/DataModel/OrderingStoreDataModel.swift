//
//  LocationDataModel.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 10/11/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import UIKit
import CoreLocation

@objc public protocol OrderingStoreDataModelDelegate {

    @objc func update(_ storeResponse: StoreResponse?, _ deliveryLocation: CLLocation?, _ error: UPError?, _ storeUpdated: Bool)

    @objc func handleLocationManagerFailure(error: Error?)
    @objc func didChangeAuthorization(status: CLAuthorizationStatus)

}

public class OrderingStoreDataModel: UrbanPiperDataModel {

    private struct OrderingStoreUserDefaultKeys {
        static let nearestStoreResponseKey: String = "NearestStoreResponse"
    }

    @objc public static private(set) var shared: OrderingStoreDataModel = OrderingStoreDataModel(deliveryLocationDataModel: DeliveryLocationDataModel.shared)

    private typealias WeakRefDataModelDelegate = WeakRef<OrderingStoreDataModelDelegate>

    private var observers = [WeakRefDataModelDelegate]()

    public var pickupStore: Store? {
        didSet {
            guard let store = pickupStore else { return }
            if let previousBizId = oldValue?.bizLocationId, previousBizId != store.bizLocationId {
                CartManager.shared.clearCart()
            }
            deliveryOption = .pickUp
            _ = observers.map { $0.value?.update(nil, nil, nil, true) }
        }
    }
    
    public var deliveryOption: DeliveryOption = .delivery {
        didSet {
            let pickupStoreVal = pickupStore
            
            switch deliveryOption {
            case .delivery:
                pickupStore = nil
            case .pickUp: break
            }
            
            guard oldValue != deliveryOption else { return }
            
            guard let deliveryBizId = nearestStoreResponse?.store?.bizLocationId, let pickupStoreBizId = pickupStoreVal?.bizLocationId else {
                CartManager.shared.clearCart()
                return
            }
            
            guard deliveryBizId != pickupStoreBizId else { return }
            CartManager.shared.clearCart()
        }
    }

    @objc public var nearestStoreResponse: StoreResponse? = {
        guard let storeResponseData: Data = UserDefaults.standard.object(forKey: OrderingStoreUserDefaultKeys.nearestStoreResponseKey) as? Data else { return nil }
        StoreResponse.registerClassName()
        StoreResponse.registerClassNameUrbanPiperSDK()
        Biz.registerClassName()
        Biz.registerClassNameUrbanPiperSDK()
        Store.registerClassName()
        Store.registerClassNameUrbanPiperSDK()
        FeedbackConfig.registerClassName()
        FeedbackConfig.registerClassNameUrbanPiperSDK()
        TimeSlot.registerClassName()
        TimeSlot.registerClassNameUrbanPiperSDK()
        Choice.registerClassName()
        Choice.registerClassNameUrbanPiperSDK()


        guard let storeResponse: StoreResponse = NSKeyedUnarchiver.unarchiveObject(with: storeResponseData) as? StoreResponse else { return nil }
        return storeResponse
        }()
        {
        didSet {
            guard let storeResponse = nearestStoreResponse else {
                UserDefaults.standard.removeObject(forKey: OrderingStoreUserDefaultKeys.nearestStoreResponseKey)
                CartManager.shared.clearCart()
                return
            }
            
            if let previousStoreId = oldValue?.store?.bizLocationId, let currentStoreId = storeResponse.store?.bizLocationId, previousStoreId != currentStoreId {
                
                if let store = storeResponse.store {
                    
                    if let deliverAddress = DeliveryLocationDataModel.shared.deliveryAddress?.fullAddress {
                        if let coordinate = DeliveryLocationDataModel.shared.deliveryLocation?.coordinate {
                            AnalyticsManager.shared.nearestStoreFound(lat: coordinate.latitude,
                                                                      lng: coordinate.longitude,
                                                                      storeName: store.name)
                        }

                        if store.closingDay || store.isStoreClosed {
                            if let coordinate = DeliveryLocationDataModel.shared.deliveryLocation?.coordinate {
                                AnalyticsManager.shared.nearestStoreClosed(lat: coordinate.latitude,
                                                                           lng: coordinate.longitude,
                                                                           deliveryAddress: deliverAddress,
                                                                           storeName: store.name)
                            }
                            
                        } else if store.temporarilyClosed {
                            if let coordinate = DeliveryLocationDataModel.shared.deliveryLocation?.coordinate {
                                AnalyticsManager.shared.nearestStoreTemporarilyClosed(lat: coordinate.latitude,
                                                                                      lng: coordinate.longitude,
                                                                                      deliveryAddress: deliverAddress,
                                                                                      storeName: store.name)
                            }
                        }
                    }
                } else {
                    if let coordinate = DeliveryLocationDataModel.shared.deliveryLocation?.coordinate {
                        AnalyticsManager.shared.noStoresNearBy(lat: coordinate.latitude, lng: coordinate.longitude)
                    }
                }
                CartManager.shared.clearCart()
            }

            let storeResponseData: Data = NSKeyedArchiver.archivedData(withRootObject: storeResponse)

            UserDefaults.standard.set(storeResponseData, forKey: OrderingStoreUserDefaultKeys.nearestStoreResponseKey)
        }
    }

    var previousStoreResponse: StoreResponse?
    
    public var orderingStore: Store? {
        switch deliveryOption {
        case .delivery:
            return nearestStoreResponse?.store
        case .pickUp:
            return pickupStore
        }
    }

    public typealias UpdateCompletionBlock = (StoreResponse?, UPError?) -> Void
    var updateCompletionBlock: UpdateCompletionBlock?

    var isFetchingNearestStoreForLocation: CLLocation?
    
    public init(deliveryLocationDataModel: DeliveryLocationDataModel) {
        super.init()

        deliveryLocationDataModel.dataModelDelegate = self
    }

    @objc public func addObserver(delegate: OrderingStoreDataModelDelegate) {
        let weakRefDataModelDelegate: WeakRefDataModelDelegate = WeakRefDataModelDelegate(value: delegate)
        observers.append(weakRefDataModelDelegate)
        observers = observers.filter { $0.value != nil }
    }
    
    
    public func removeObserver(delegate: OrderingStoreDataModelDelegate) {
        guard let index = (observers.index { $0.value === delegate }) else { return }
        observers.remove(at: index)
    }


    @objc public func updateLocationAndNearestStore(forced: Bool = true, completion: UpdateCompletionBlock? = nil) {
        updateCompletionBlock = completion
        DeliveryLocationDataModel.shared.updateCurrentUserLocation(forced: forced)
    }
    
    
    public func setPickupFrom(store: Store) {
        DeliveryLocationDataModel.shared.nextLocationUpdateDate = Calendar.current.date(byAdding: .minute,
                                                                                        value: Int(DeliveryLocationDataModel.locationUpdateTimeInterval),
                                                                                        to: Date())
        pickupStore = store
    }

}

//  MARK: API Calls

extension OrderingStoreDataModel {

    fileprivate func fetchNearestStore(location: CLLocation) {

        guard isFetchingNearestStoreForLocation == nil || isFetchingNearestStoreForLocation! != location else {
            _ = observers.map { $0.value?.update(nil, location, nil, false) }
            return
        }

        isFetchingNearestStoreForLocation = location

        previousStoreResponse = OrderingStoreDataModel.shared.nearestStoreResponse
        
        _ = observers.map { $0.value?.update(nil, location, nil, false) }
        
        let dataTask: URLSessionDataTask = APIManager.shared.fetchNearestStore(location.coordinate, completion: { [weak self] (data) in
            defer {
                self?.deliveryOption = .delivery
                
                _ = self?.observers.map { $0.value?.update(OrderingStoreDataModel.shared.nearestStoreResponse, location, nil, true) }
                self?.updateCompletionBlock?(OrderingStoreDataModel.shared.nearestStoreResponse, nil)
                self?.updateCompletionBlock = nil
            }

            self?.isFetchingNearestStoreForLocation = nil

            guard let response = data else { return }
            OrderingStoreDataModel.shared.nearestStoreResponse = response
            
            }, failure: { [weak self] (upError) in
                OrderingStoreDataModel.shared.nearestStoreResponse = nil
                self?.isFetchingNearestStoreForLocation = nil

                defer {
                    _ = self?.observers.map { $0.value?.update(nil, nil, upError, false) }
                    self?.updateCompletionBlock?(nil, upError)
                    self?.updateCompletionBlock = nil
                }
        })

        addOrCancelDataTask(dataTask: dataTask)
    }
}

//  MARK: Custom Delivery Location Selection

extension OrderingStoreDataModel {

    @objc public func updateNearestStore(for location: CLLocation?, address: OrderDeliveryAddress? = nil, completion: UpdateCompletionBlock?) {
        guard let loc = location else {
            _ = observers.map { $0.value?.update(nil, nil, nil, false) }
            completion?(nil, nil)
            return
        }
        
        updateCompletionBlock = completion
        DeliveryLocationDataModel.shared.setCustomDelivery(location: loc, address: address)
    }
}

extension OrderingStoreDataModel: DeliveryLocationDataModelDelegate {

    public func update(_ deliveryLocation: CLLocation?, _ deliveryAddress: OrderDeliveryAddress?, _ upError: UPError?) {
        if let error = upError {
            _ = observers.map { $0.value?.update(nil, nil, error, false) }
            updateCompletionBlock?(nil, error)
            updateCompletionBlock = nil
        } else if deliveryLocation != nil && (deliveryAddress == nil || OrderingStoreDataModel.shared.nearestStoreResponse == nil) {
            fetchNearestStore(location: deliveryLocation!)
            _ = observers.map { $0.value?.update(OrderingStoreDataModel.shared.nearestStoreResponse, deliveryLocation, nil, false) }
        } else if deliveryLocation != nil, deliveryAddress != nil, upError == nil {
            deliveryOption = .delivery
            
            _ = observers.map { $0.value?.update(OrderingStoreDataModel.shared.nearestStoreResponse, deliveryLocation, nil, false) }
            
            updateCompletionBlock?(OrderingStoreDataModel.shared.nearestStoreResponse, nil)
            updateCompletionBlock = nil
        } else if DeliveryLocationDataModel.shared.deliveryLocation == nil, DeliveryLocationDataModel.shared.deliveryAddress == nil {
            _ = observers.map { $0.value?.update(nil, nil, nil, false) }
            updateCompletionBlock?(nil, nil)
            updateCompletionBlock = nil
        }
    }

    public func handleLocationManagerFailure(error: Error?) {
        _ = observers.map { $0.value?.handleLocationManagerFailure(error: error) }
    }

    public func didChangeAuthorization(status: CLAuthorizationStatus) {
        _ = observers.map { $0.value?.didChangeAuthorization(status: status) }
    }

}


//  App State Management

extension OrderingStoreDataModel {

    @objc open override func appWillEnterForeground() {
        guard let deliveryLocation = DeliveryLocationDataModel.shared.deliveryLocation,
            let deliveryAddress = DeliveryLocationDataModel.shared.deliveryAddress,
            OrderingStoreDataModel.shared.nearestStoreResponse == nil else { return }
        update(deliveryLocation, deliveryAddress, nil)
    }

    @objc open override func appDidEnterBackground() {
    }
    
}

//  Reachability

extension OrderingStoreDataModel {

    @objc open override func networkIsAvailable() {
        guard let deliveryLocation = DeliveryLocationDataModel.shared.deliveryLocation,
            let deliveryAddress = DeliveryLocationDataModel.shared.deliveryAddress,
            OrderingStoreDataModel.shared.nearestStoreResponse == nil else { return }
        update(deliveryLocation, deliveryAddress, nil)
    }

}
