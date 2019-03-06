//
//  ResetPasswordBuilder.swift
//  UrbanPiperSDK
//
//  Created by Vid on 09/02/19.
//  Copyright © 2019 UrbanPiper. All rights reserved.
//

import UIKit

public class ResetPasswordBuilder: NSObject {

    internal var phone: String?
    
    internal override init() {
    }

    @discardableResult public func forgotPassword(phone: String, completion: @escaping (GenericResponse?) -> Void, failure: @escaping APIFailure) -> URLSessionDataTask {
        self.phone = phone
        return UserManager.shared.forgotPassword(phone: phone, completion: completion, failure: failure)
    }
    
    @discardableResult public func resetPassword(otp: String, password: String, confirmPassword: String, completion: @escaping ((GenericResponse?) -> Void), failure: @escaping APIFailure) -> URLSessionDataTask {
        assert(phone != nil, "forgotPassword method should be called first")
        return UserManager.shared.resetPassword(phone: phone!, otp: otp, password: password, confirmPassword: confirmPassword, completion: completion, failure: failure)
    }
    
}