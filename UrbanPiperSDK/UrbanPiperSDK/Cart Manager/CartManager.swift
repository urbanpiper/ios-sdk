//
//  CartManager.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 26/12/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import UIKit

@objc public protocol CartManagerDelegate {

    func refreshCartUI()
    func handleCart(error: UPError?)

}

public class CartManager: NSObject {

    @objc public static let shared = CartManager()

    private typealias WeakRefCartManagerDelegate = WeakRef<CartManagerDelegate>
    private var cartManagerObservers = [WeakRefCartManagerDelegate]()

    @objc public var cartItems = [ItemObject]()

    public var groupedCartItems: [[ItemObject]] {
        return Array(Dictionary(grouping:cartItems){$0.category.id ?? 0}.values)
    }
    
    @objc public var isReorder = false

    @objc public var cartValue: Decimal {
        return cartItems.reduce (0.0, { $0 + ($1.totalAmount * Decimal($1.selectedQuantity)).rounded } )
    }

    @objc public var cartCount: Int {
        return cartItems.reduce (0, { $0 + $1.selectedQuantity } )
    }

    @objc public var cartPreOrderStartTime: Date? {
        var preOrderItems = cartItems.filter { $0.preOrderStartTime != nil }
        guard preOrderItems.count > 0 else { return nil }

        if preOrderItems.count > 1 {
            preOrderItems.sort { $0.preOrderStartTime! < $1.preOrderStartTime! }
        }
        
        let earliestTime = preOrderItems.last!.preOrderStartTime!
        return Date(timeIntervalSince1970: TimeInterval(earliestTime / 1000))
    }

    @objc public func cartCount(for item: ItemObject) -> Int {
        return cartItems.reduce (0, { $0 + ($1.id == item.id ? $1.selectedQuantity : 0) } )
    }

}

// Cart Observer Management

extension CartManager {

    @objc public static func addObserver(delegate: CartManagerDelegate) {
        let weakRefCartManagerDelegate = WeakRefCartManagerDelegate(value: delegate)
        shared.cartManagerObservers.append(weakRefCartManagerDelegate)
    }


    @objc public static func removeObserver(delegate: CartManagerDelegate) {
        guard let index = (shared.cartManagerObservers.index { $0.value === delegate }) else { return }
        shared.cartManagerObservers.remove(at: index)
    }
    
}


// MARK: Cart Management

extension CartManager {

    @objc public func add(itemObject: ItemObject) {
//        AnalyticsManager.shared.itemAddedToCart(itemObject: itemObject)
        
        if let item = cartItems.filter({ $0 == itemObject }).last {
            if item.isItemQuantityAvailable(quantity: itemObject.selectedQuantity) {
                item.selectedQuantity += itemObject.selectedQuantity
            } else {
                let upError = UPError(type: .maxOrderableQuantityAdded(item.currentStock))
                let _ = cartManagerObservers.map { $0.value?.handleCart(error: upError) }
            }
        } else {
            let object = itemObject.copy() as! ItemObject
            object.selectedQuantity = itemObject.selectedQuantity

            cartItems.append(object)
        }
        
        let _ = cartManagerObservers.map { $0.value?.refreshCartUI() }
    }

    public func remove(itemObject: ItemObject) {
        guard let item = cartItems.filter({ $0.id == itemObject.id }).last else { return }
        item.selectedQuantity -= itemObject.selectedQuantity

        guard item.selectedQuantity == 0 else {
            let _ = cartManagerObservers.map { $0.value?.refreshCartUI() }
            return
        }
        guard let index = cartItems.index(of: item) else {
            let _ = cartManagerObservers.map { $0.value?.refreshCartUI() }
            return
        }
        cartItems.remove(at: index)

        let _ = cartManagerObservers.map { $0.value?.refreshCartUI() }
    }

    @objc public func clearCart() {
        isReorder = false
        cartItems.removeAll()
        let _ = cartManagerObservers.map { $0.value?.refreshCartUI() }
    }

}
