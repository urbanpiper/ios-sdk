//
//	Biz.swift
//
//	Create by Vidhyadharan Mohanram on 29/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


@objc public class Biz : NSObject, NSCoding{
    
    static public var shared: Biz?

	public var contactPhone : String!
	public var currency : String!
	public var deliveryMinOffsetTime : Int!
	public var feedbackConfig : [FeedbackConfig]!
	public var gst : String!
	public var isPickupEnabled : Bool!
	public var minOrderTotal : Decimal!
	public var minimumWalletCreditThreshold : Float!
	public var msgNearestStoreClosed : String!
	public var msgNoStoresNearby : String!
	public var msgStoreClosedTemporary : String!
	public var orderDeliveryRadius : Int!
	public var paymentOptions : [String]!
    public var paypalClientToken : String!
	public var pgProvider : String!
	public var pickupMinOffsetTime : Int!
	public var preProcess : Bool!
	public var referralShareLbl : String!
	public var referralUiLbl : String!
	public var simplClientId : String!
	public var timeSlots : [TimeSlot]!
	public var timezone : String!
	public var tin : String!
	public var usePointOfDelivery : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	public init(fromDictionary dictionary:  [String:Any]){
		contactPhone = dictionary["contact_phone"] as? String
		currency = dictionary["currency"] as? String
		deliveryMinOffsetTime = dictionary["delivery_min_offset_time"] as? Int
		feedbackConfig = [FeedbackConfig]()
		if let feedbackConfigArray = dictionary["feedback_config"] as? [[String:Any]]{
			for dic in feedbackConfigArray{
				let value = FeedbackConfig(fromDictionary: dic)
				feedbackConfig.append(value)
			}
		}
		gst = dictionary["gst"] as? String
		isPickupEnabled = dictionary["is_pickup_enabled"] as? Bool
        
        if let val = dictionary["min_order_total"] as? Decimal {
            print("decimal amount value \(val)")
            minOrderTotal = val
        } else if let val = dictionary["min_order_total"] as? Double {
            print("double amount value \(val)")
            minOrderTotal = Decimal(val).rounded
            print("Decimal Double \((NSDecimalNumber(decimal: minOrderTotal).doubleValue))")
        } else if let val = dictionary["min_order_total"] as? Float {
            minOrderTotal = Decimal(Double(val)).rounded
            print("float amount value \(val)")
        } else if let val = dictionary["min_order_total"] as? Int {
            print("int amount value \(val)")
            minOrderTotal = Decimal(val).rounded
            print("Decimal Double \((NSDecimalNumber(decimal: minOrderTotal).doubleValue))")
        } else {
            minOrderTotal = Decimal(0).rounded
            print("amount value nil")
        }
        
		minimumWalletCreditThreshold = dictionary["minimum_wallet_credit_threshold"] as? Float
		msgNearestStoreClosed = dictionary["msg_nearest_store_closed"] as? String
		msgNoStoresNearby = dictionary["msg_no_stores_nearby"] as? String
		msgStoreClosedTemporary = dictionary["msg_store_closed_temporary"] as? String
		orderDeliveryRadius = dictionary["order_delivery_radius"] as? Int
		paymentOptions = dictionary["payment_options"] as? [String]
		paypalClientToken = dictionary["paypal_client_token"] as? String
		pgProvider = dictionary["pg_provider"] as? String
		pickupMinOffsetTime = dictionary["pickup_min_offset_time"] as? Int
		preProcess = dictionary["pre_process"] as? Bool
		referralShareLbl = dictionary["referral_share_lbl"] as? String
		referralUiLbl = dictionary["referral_ui_lbl"] as? String
		simplClientId = dictionary["simpl_client_id"] as? String
		timeSlots = [TimeSlot]()
		if let timeSlotsArray = dictionary["time_slots"] as? [[String:Any]]{
			for dic in timeSlotsArray{
				let value = TimeSlot(fromDictionary: dic)
				timeSlots.append(value)
			}
		}
		timezone = dictionary["timezone"] as? String
		tin = dictionary["tin"] as? String
		usePointOfDelivery = dictionary["use_point_of_delivery"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	public func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if contactPhone != nil{
			dictionary["contact_phone"] = contactPhone
		}
		if currency != nil{
			dictionary["currency"] = currency
		}
		if deliveryMinOffsetTime != nil{
			dictionary["delivery_min_offset_time"] = deliveryMinOffsetTime
		}
		if feedbackConfig != nil{
            var dictionaryElements = [[String:Any]]()
			for feedbackConfigElement in feedbackConfig {
				dictionaryElements.append(feedbackConfigElement.toDictionary())
			}
			dictionary["feedback_config"] = dictionaryElements
		}
		if gst != nil{
			dictionary["gst"] = gst
		}
		if isPickupEnabled != nil{
			dictionary["is_pickup_enabled"] = isPickupEnabled
		}
		if minOrderTotal != nil{
			dictionary["min_order_total"] = minOrderTotal
		}
		if minimumWalletCreditThreshold != nil{
			dictionary["minimum_wallet_credit_threshold"] = minimumWalletCreditThreshold
		}
		if msgNearestStoreClosed != nil{
			dictionary["msg_nearest_store_closed"] = msgNearestStoreClosed
		}
		if msgNoStoresNearby != nil{
			dictionary["msg_no_stores_nearby"] = msgNoStoresNearby
		}
		if msgStoreClosedTemporary != nil{
			dictionary["msg_store_closed_temporary"] = msgStoreClosedTemporary
		}
		if orderDeliveryRadius != nil{
			dictionary["order_delivery_radius"] = orderDeliveryRadius
		}
		if paymentOptions != nil{
			dictionary["payment_options"] = paymentOptions
		}
		if paypalClientToken != nil{
			dictionary["paypal_client_token"] = paypalClientToken
		}
		if pgProvider != nil{
			dictionary["pg_provider"] = pgProvider
		}
		if pickupMinOffsetTime != nil{
			dictionary["pickup_min_offset_time"] = pickupMinOffsetTime
		}
		if preProcess != nil{
			dictionary["pre_process"] = preProcess
		}
		if referralShareLbl != nil{
			dictionary["referral_share_lbl"] = referralShareLbl
		}
		if referralUiLbl != nil{
			dictionary["referral_ui_lbl"] = referralUiLbl
		}
		if simplClientId != nil{
			dictionary["simpl_client_id"] = simplClientId
		}
		if timeSlots != nil{
            var dictionaryElements = [[String:Any]]()
			for timeSlotsElement in timeSlots {
				dictionaryElements.append(timeSlotsElement.toDictionary())
			}
			dictionary["time_slots"] = dictionaryElements
		}
		if timezone != nil{
			dictionary["timezone"] = timezone
		}
		if tin != nil{
			dictionary["tin"] = tin
		}
		if usePointOfDelivery != nil{
			dictionary["use_point_of_delivery"] = usePointOfDelivery
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required public init(coder aDecoder: NSCoder)
	{
         contactPhone = aDecoder.decodeObject(forKey: "contact_phone") as? String
         currency = aDecoder.decodeObject(forKey: "currency") as? String
         deliveryMinOffsetTime = aDecoder.decodeObject(forKey: "delivery_min_offset_time") as? Int
        feedbackConfig = aDecoder.decodeObject(forKey :"feedback_config") as? [FeedbackConfig]
         gst = aDecoder.decodeObject(forKey: "gst") as? String
         isPickupEnabled = aDecoder.decodeObject(forKey: "is_pickup_enabled") as? Bool
         minOrderTotal = aDecoder.decodeObject(forKey: "min_order_total") as? Decimal
         minimumWalletCreditThreshold = aDecoder.decodeObject(forKey: "minimum_wallet_credit_threshold") as? Float
         msgNearestStoreClosed = aDecoder.decodeObject(forKey: "msg_nearest_store_closed") as? String
         msgNoStoresNearby = aDecoder.decodeObject(forKey: "msg_no_stores_nearby") as? String
         msgStoreClosedTemporary = aDecoder.decodeObject(forKey: "msg_store_closed_temporary") as? String
         orderDeliveryRadius = aDecoder.decodeObject(forKey: "order_delivery_radius") as? Int
         paymentOptions = aDecoder.decodeObject(forKey: "payment_options") as? [String]
         paypalClientToken = aDecoder.decodeObject(forKey: "paypal_client_token") as? String
         pgProvider = aDecoder.decodeObject(forKey: "pg_provider") as? String
         pickupMinOffsetTime = aDecoder.decodeObject(forKey: "pickup_min_offset_time") as? Int
         preProcess = aDecoder.decodeObject(forKey: "pre_process") as? Bool
         referralShareLbl = aDecoder.decodeObject(forKey: "referral_share_lbl") as? String
         referralUiLbl = aDecoder.decodeObject(forKey: "referral_ui_lbl") as? String
         simplClientId = aDecoder.decodeObject(forKey: "simpl_client_id") as? String
        timeSlots = aDecoder.decodeObject(forKey :"time_slots") as? [TimeSlot]
         timezone = aDecoder.decodeObject(forKey: "timezone") as? String
         tin = aDecoder.decodeObject(forKey: "tin") as? String
         usePointOfDelivery = aDecoder.decodeObject(forKey: "use_point_of_delivery") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc public func encode(with aCoder: NSCoder)
	{
		if contactPhone != nil{
			aCoder.encode(contactPhone, forKey: "contact_phone")
		}
		if currency != nil{
			aCoder.encode(currency, forKey: "currency")
		}
		if deliveryMinOffsetTime != nil{
			aCoder.encode(deliveryMinOffsetTime, forKey: "delivery_min_offset_time")
		}
		if feedbackConfig != nil{
			aCoder.encode(feedbackConfig, forKey: "feedback_config")
		}
		if gst != nil{
			aCoder.encode(gst, forKey: "gst")
		}
		if isPickupEnabled != nil{
			aCoder.encode(isPickupEnabled, forKey: "is_pickup_enabled")
		}
		if minOrderTotal != nil{
			aCoder.encode(minOrderTotal, forKey: "min_order_total")
		}
		if minimumWalletCreditThreshold != nil{
			aCoder.encode(minimumWalletCreditThreshold, forKey: "minimum_wallet_credit_threshold")
		}
		if msgNearestStoreClosed != nil{
			aCoder.encode(msgNearestStoreClosed, forKey: "msg_nearest_store_closed")
		}
		if msgNoStoresNearby != nil{
			aCoder.encode(msgNoStoresNearby, forKey: "msg_no_stores_nearby")
		}
		if msgStoreClosedTemporary != nil{
			aCoder.encode(msgStoreClosedTemporary, forKey: "msg_store_closed_temporary")
		}
		if orderDeliveryRadius != nil{
			aCoder.encode(orderDeliveryRadius, forKey: "order_delivery_radius")
		}
		if paymentOptions != nil{
			aCoder.encode(paymentOptions, forKey: "payment_options")
		}
		if paypalClientToken != nil{
			aCoder.encode(paypalClientToken, forKey: "paypal_client_token")
		}
		if pgProvider != nil{
			aCoder.encode(pgProvider, forKey: "pg_provider")
		}
		if pickupMinOffsetTime != nil{
			aCoder.encode(pickupMinOffsetTime, forKey: "pickup_min_offset_time")
		}
		if preProcess != nil{
			aCoder.encode(preProcess, forKey: "pre_process")
		}
		if referralShareLbl != nil{
			aCoder.encode(referralShareLbl, forKey: "referral_share_lbl")
		}
		if referralUiLbl != nil{
			aCoder.encode(referralUiLbl, forKey: "referral_ui_lbl")
		}
		if simplClientId != nil{
			aCoder.encode(simplClientId, forKey: "simpl_client_id")
		}
		if timeSlots != nil{
			aCoder.encode(timeSlots, forKey: "time_slots")
		}
		if timezone != nil{
			aCoder.encode(timezone, forKey: "timezone")
		}
		if tin != nil{
			aCoder.encode(tin, forKey: "tin")
		}
		if usePointOfDelivery != nil{
			aCoder.encode(usePointOfDelivery, forKey: "use_point_of_delivery")
		}

	}

}
