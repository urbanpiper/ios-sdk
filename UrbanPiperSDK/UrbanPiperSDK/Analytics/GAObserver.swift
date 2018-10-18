//
//  GAObserver.swift
//  UrbanPiperSDK
//
//  Created by Vid on 16/10/18.
//

import UIKit
import GoogleAnalyticsSDK

class GAObserver: AnalyticsObserver {
    
    override func initializeTracker() {
        let plistPath: String = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        var googleServiceInfoPlist: [String: Any] = NSDictionary(contentsOfFile: plistPath) as! [String: Any]
        
        guard let gai: GAI = GAI.sharedInstance(), let trackingId: String = googleServiceInfoPlist["TRACKING_ID"] as? String else { return }
        gai.tracker(withTrackingId: trackingId)
        
        gai.trackUncaughtExceptions = true
        
        gai.logger.logLevel = .error
    }

    override func track(event: AnalyticsEvent) {
        switch event {
        case .nearestStoreFound:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
                                                                   action: nil,
                                                                   label: "nearest-store-found",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .noStoreNearby:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
                                                                   action: nil,
                                                                   label: "no-stores-nearby",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .nearestStoreClosedTemp:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
                                                                   action: nil,
                                                                   label: "nearest-store-closed-temp",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .nearestStoreClosed:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
                                                                   action: nil,
                                                                   label: "nearest-store-closed",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
//        case .nearestStoreClosedToday:
//            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
//            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
//                                                                   action: nil,
//                                                                   label: "nearest-store-closed",
//                                                                   value: 0).build() as! [AnyHashable : Any]
//            tracker.send(eventDictionary)
        case .itemSearch:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
                                                                   action: nil,
                                                                   label: "item-search",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .couponSuccess(let discount, let couponCode, _, _):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "coupon-success",
                                                                   action: nil,
                                                                   label: couponCode,
                                                                   value: NSDecimalNumber(decimal:discount)).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .couponFailed(_, let couponCode, _, _):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "coupon-failure",
                                                                   action: nil,
                                                                   label: couponCode,
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .passwordReset:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "password-reset",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .loginSuccess:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                               action: nil,
                                                               label: "login-success",
                                                               value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .loginFailed:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                               action: nil,
                                                               label: "login-failed",
                                                               value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .resendOTP:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "resend-otp",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .signupStart:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "signup-start",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .signupComplete:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "signup-complete",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .walletReloadInit(let amount, _):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "reload-init",
                                                                   value: amount).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .successfulWalletReload(let amount, _):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                               action: nil,
                                                               label: "reload-success",
                                                               value: amount).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .failedWalletReload(let amount, _):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "reload-failed",
                                                                   value: amount).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .referralSent:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "referral-sent",
                                                                   value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .logout:
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary: [AnyHashable : Any] = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                                        action: "logout",
                                                                                        label: "logout",
                                                                                        value: 0).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .addToCart(let item, _, _):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let product: GAIEcommerceProduct = GAIEcommerceProduct()
            product.setId("\(item.id!)")
            product.setName(item.itemTitle)
            product.setQuantity(item.quantity as NSNumber)
            product.setPrice(item.totalAmount as NSNumber)
            product.setCategory(item.category.name)
            
            let productAction: GAIEcommerceProductAction = GAIEcommerceProductAction()
            productAction.setAction(kGAIPAAdd)
            
            let screenBuilder: GAIDictionaryBuilder = GAIDictionaryBuilder.createScreenView()!
            screenBuilder.add(product)
            screenBuilder.setProductAction(productAction)
            
            tracker.send((screenBuilder.build() as! [AnyHashable : Any]))
        case .removeFromCart(let item):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let product: GAIEcommerceProduct = GAIEcommerceProduct()
            product.setId("\(item.id!)")
            product.setName(item.itemTitle)
            product.setQuantity(item.quantity as NSNumber)
            product.setPrice(item.totalAmount as NSNumber)
            product.setCategory(item.category.name)
            
            let productAction: GAIEcommerceProductAction = GAIEcommerceProductAction()
            productAction.setAction(kGAIPARemove)
            
            let screenBuilder: GAIDictionaryBuilder = GAIDictionaryBuilder.createScreenView()!
            screenBuilder.add(product)
            screenBuilder.setProductAction(productAction)
            
            tracker.send((screenBuilder.build() as! [AnyHashable : Any]))
        case .productClicked(let item):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let product: GAIEcommerceProduct = GAIEcommerceProduct()
            product.setId("\(item.id!)")
            product.setName(item.itemTitle)
            product.setCategory(item.category.name)
            
            let productAction: GAIEcommerceProductAction = GAIEcommerceProductAction()
            productAction.setAction(kGAIPADetail)
            
            let screenBuilder: GAIDictionaryBuilder = GAIDictionaryBuilder.createScreenView()!
            screenBuilder.add(product)
            screenBuilder.setProductAction(productAction)
            
            tracker.send((screenBuilder.build() as! [AnyHashable : Any]))
        case .purchaseCompleted(let orderID, let orderPaymentDataModel, _):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary: [AnyHashable : Any] = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
                                                                                        action: "purchase",
                                                                                        label: "success",
                                                                                        value: orderPaymentDataModel.itemsTotalPrice as NSNumber).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
            
            let eventBuilder = GAIDictionaryBuilder.createEvent(withCategory: nil, action: nil, label: nil, value: nil)!
            
            let productAction: GAIEcommerceProductAction = GAIEcommerceProductAction()
            productAction.setAction(kGAIPAPurchase)
            productAction.setTransactionId(orderID)
            productAction.setAffiliation("UrbanPiper")
            productAction.setRevenue(NSDecimalNumber(decimal: orderPaymentDataModel.itemsTotalPrice))
            productAction.setTax(NSDecimalNumber(decimal: orderPaymentDataModel.itemTaxes ?? Decimal.zero))
            
            let deliveryCharge = orderPaymentDataModel.selectedDeliveryOption == .pickUp ? Decimal.zero : orderPaymentDataModel.deliveryCharge
            productAction.setShipping(NSDecimalNumber(decimal: deliveryCharge))
            productAction.setCheckoutOption(orderPaymentDataModel.selectedPaymentOption.rawValue)
            
            let couponCode = orderPaymentDataModel.applyCouponResponse != nil ? orderPaymentDataModel.couponCode : nil
            productAction.setCouponCode(couponCode)
            
            if let items = orderPaymentDataModel.orderResponse?.items {
                for item in items {
                    let product: GAIEcommerceProduct = GAIEcommerceProduct()
                    product.setId("\(item.id!)")
                    product.setName(item.itemTitle)
                    product.setQuantity(NSNumber(value: item.quantity))
                    product.setPrice(NSDecimalNumber(decimal: item.itemPrice))
                    product.setCategory(item.category.name)
                    
                    eventBuilder.add(product)
                }
            }
            
            eventBuilder.setProductAction(productAction)
            tracker.send((eventBuilder.build() as! [AnyHashable : Any]))
        case .reorderInit(let amount):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "ordering",
                                                                   action: nil,
                                                                   label: "re-order",
                                                                   value: NSDecimalNumber(decimal:  amount)).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .socialAuthSignupStart(_, let platform):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "social-signup-start",
                                                                   value: platform == "google" ? 1 : 2).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .socialAuthSignupComplete(_, let platform):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "social-signup-complete",
                                                                   value: platform == "google" ? 1 : 2).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .socialLoginSuccess(_, let platform):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                               action: nil,
                                                               label: "social-login-success",
                                                               value: platform == "google" ? 1 : 2).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        case .socialLoginFailed(_, let platform):
            guard let tracker: GAITracker = GAI.sharedInstance().defaultTracker else { return }
            let eventDictionary = GAIDictionaryBuilder.createEvent(withCategory: "user",
                                                                   action: nil,
                                                                   label: "social-login-failed",
                                                                   value: platform == "google" ? 1 : 2).build() as! [AnyHashable : Any]
            tracker.send(eventDictionary)
        default: break
        }
    }
    
}