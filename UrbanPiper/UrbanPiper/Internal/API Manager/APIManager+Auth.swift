//
//  APIManager+Auth.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 09/01/18.
//  Copyright © 2018 UrbanPiper Inc. All rights reserved.
//

import Foundation

enum AuthAPI {
    case refreshToken(token: String)
    case login(phone: String, password: String)
    case forgotPassword(phone: String)
    case resetPassword(phone: String, otp: String, password: String, confirmPassword: String)
    case registerUser(name: String, phone: String, email: String, password: String, referral: Referral?)
    case createSocialUser(name: String, phone: String, email: String, gender: String?, accessToken: String, referral: Referral?)
    case verifyRegOTP(phone: String, pin: String)
    case resendOTP(phone: String)
}

extension AuthAPI: UPAPI {
    var path: String {
        switch self {
        case .refreshToken:
            return "api/v2/auth/refresh-token/"
        case .login:
            return "api/v2/auth/token/"
        case .forgotPassword:
            return "api/v1/user/password/token/"
        case .resetPassword:
            return "api/v1/user/password/"
        case .registerUser:
            return "api/v2/card/"
        case .createSocialUser:
            return "api/v2/card/"
        case .verifyRegOTP:
            return "api/v2/card/"
        case .resendOTP:
            return "api/v2/card/"
        }
    }

    var parameters: [String: String]? {
        var params: [String: String]?
        switch self {
        case .refreshToken:
            params = nil
        case .login:
            params = nil
        case .forgotPassword:
            params = nil
        case .resetPassword:
            params = nil
        case .registerUser(let name, let phone, let email, let password, _):
            params = ["customer_name": name,
                      "customer_phone": phone,
                      "email": email,
                      "password": password,
                      "channel": APIManager.channel]
        case .createSocialUser(let name, let phone, let email, let gender, let accessToken, _):
            params = ["customer_name": name,
                      "customer_phone": phone,
                      "email": email,
                      "password": accessToken,
                      "channel": APIManager.channel]

            if let gender = gender, gender.count > 0 {
                params?["gender"] = gender
            }
        case let .verifyRegOTP(phone, pin):
            params = ["customer_phone": phone,
                      "pin": pin,
                      "nopinsend": "true"]
        case let .resendOTP(phone):
            params = ["customer_phone": phone,
                      "pin": "resendotp"]
        }

        return params
    }

    var headers: [String: String]? {
        switch self {
        case .refreshToken:
            return ["Authorization": APIManager.shared.bizAuth()]
        case .login:
            return nil
        case .forgotPassword:
            return nil
        case .resetPassword:
            return nil
        case .registerUser:
            return ["Authorization": APIManager.shared.bizAuth()]
        case .createSocialUser:
            return ["Authorization": APIManager.shared.bizAuth()]
        case .verifyRegOTP:
            return ["Authorization": APIManager.shared.bizAuth()]
        case .resendOTP:
            return ["Authorization": APIManager.shared.bizAuth()]
        }
    }

    var method: HttpMethod {
        switch self {
        case .refreshToken:
            return .POST
        case .login:
            return .POST
        case .forgotPassword:
            return .POST
        case .resetPassword:
            return .POST
        case .registerUser:
            return .POST
        case .createSocialUser:
            return .POST
        case .verifyRegOTP:
            return .POST
        case .resendOTP:
            return .POST
        }
    }

    var body: [String: AnyObject]? {
        switch self {
        case let .refreshToken(token):
            return ["token": token] as [String: AnyObject]
        case let .login(phone, password):
            return ["username": phone,
                    "pass": password] as [String: AnyObject]
        case let .forgotPassword(phone):
            return ["biz_id": APIManager.shared.bizId,
                    "phone": phone] as [String: AnyObject]
        case let .resetPassword(phone, otp, password, confirmPassword):
            return ["biz_id": APIManager.shared.bizId,
                    "phone": phone,
                    "token": otp,
                    "new_password1": password,
                    "new_password2": confirmPassword] as [String: AnyObject]
        case let .registerUser(_, _, _, _, referral):
            if let params = referral?.toDictionary() {
                return ["referral": params] as [String: AnyObject]
            } else {
                return nil
            }
        case let .createSocialUser(_, _, _, _, _, referral):
            if let params = referral?.toDictionary() {
                return ["referral": params] as [String: AnyObject]
            } else {
                return nil
            }
        case .verifyRegOTP:
            return nil
        case .resendOTP:
            return nil
        }
    }
}

/* extension APIManager {

 @discardableResult internal func refreshToken(token: String,
                            completion: APICompletion<RefreshTokenResponse>?,
                            failure: APIFailure?) -> URLSessionDataTask {

     let urlString: String = "\(APIManager.baseUrl)/api/v2/auth/refresh-token/"

     let url: URL = URL(string: urlString)!

     var urlRequest: URLRequest = URLRequest(url: url)

     urlRequest.httpMethod = "POST"

     let params: [String: Any] = ["token": token]

     urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

     return apiRequest(urlRequest: &urlRequest, headers: ["Authorization" : bizAuth()], completion: completion, failure: failure)
 }

 @objc internal func login(phone: String,
                         password: String,
                         completion: APICompletion<LoginResponse>?,
                         failure: APIFailure?) -> URLSessionDataTask {

     let urlString: String = "\(APIManager.baseUrl)/api/v2/auth/token/"

     let url: URL = URL(string: urlString)!

     var urlRequest: URLRequest = URLRequest(url: url)

     urlRequest.httpMethod = "POST"

     let params: [String: Any] = ["username": phone,
                                  "pass": password]

     urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

     return apiRequest(urlRequest: &urlRequest, completion: completion, failure: failure)
 }

 @objc internal func forgotPassword(phone: String,
                                  completion: APICompletion<GenericResponse>?,
                                  failure: APIFailure?) -> URLSessionDataTask {

     let urlString: String = "\(APIManager.baseUrl)/api/v1/user/password/token/"

     let url: URL = URL(string: urlString)!

     var urlRequest: URLRequest = URLRequest(url: url)
     urlRequest.httpMethod = "POST"

     let params: [String: Any] = ["biz_id": bizId,
                                  "phone": phone]

     urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

     return apiRequest(urlRequest: &urlRequest, completion: completion, failure: failure)
 }

 @objc internal func resetPassword(phone: String,
                                 otp: String,
                                 password: String,
                                 confirmPassword: String,
                                 completion: APICompletion<GenericResponse>?,
                                 failure: APIFailure?) -> URLSessionDataTask {

     let urlString: String = "\(APIManager.baseUrl)/api/v1/user/password/"

     let url: URL = URL(string: urlString)!

     var urlRequest: URLRequest = URLRequest(url: url)
     urlRequest.httpMethod = "POST"

     let params: [String: Any] = ["biz_id": bizId,
                   "phone": phone,
                   "token": otp,
                   "new_password1": password,
                   "new_password2": confirmPassword]

     urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

     return apiRequest(urlRequest: &urlRequest, completion: completion, failure: failure)
 }

 }

 //  MARK: Create User

 extension APIManager {

 @objc internal func registerUser(name: String,
                              phone: String,
                              email: String,
                              password: String,
                              referralObject: Referral? = nil,
                              completion: APICompletion<RegistrationResponse>?,
                              failure: APIFailure?) -> URLSessionDataTask {
     AnalyticsManager.shared.track(event: .signupStart(phone: phone))
     let urlString: String = "\(APIManager.baseUrl)/api/v2/card/?customer_name=\(name)&customer_phone=\(phone)&email=\(email)&password=\(password)&channel=\(APIManager.channel)"

     var cs: CharacterSet = CharacterSet.urlQueryAllowed
     cs.remove(charactersIn: "@+")
     let encodedURlString: String = urlString.addingPercentEncoding(withAllowedCharacters: cs)!

     let url: URL = URL(string: encodedURlString)!

     var urlRequest: URLRequest = URLRequest(url: url)

     urlRequest.httpMethod = "POST"

     if let params = referralObject {
         urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: ["referral": params.toDictionary()], options: [])
     }

     return apiRequest(urlRequest: &urlRequest, headers: ["Authorization" : bizAuth()], completion: completion, failure: failure)
 }

 @objc internal func createSocialUser(name: String,
                                    phone: String,
                                    email: String,
                                    gender: String? = nil,
                                    accessToken: String,
                                    referralObject: Referral? = nil,
                                    completion: APICompletion<RegistrationResponse>?,
                                    failure: APIFailure?) -> URLSessionDataTask {

     var urlString: String = "\(APIManager.baseUrl)/api/v2/card/?customer_name=\(name)&customer_phone=\(phone)&email=\(email)&password=\(accessToken)&channel=\(APIManager.channel)"

     if gender != nil {
         urlString = "\(urlString)&gender=\(gender!)"
     }

     var cs: CharacterSet = CharacterSet.urlQueryAllowed
     cs.remove(charactersIn: "@+")
     let encodedURlString: String = urlString.addingPercentEncoding(withAllowedCharacters: cs)!

     let url: URL = URL(string: encodedURlString)!

     var urlRequest: URLRequest = URLRequest(url: url)

     urlRequest.httpMethod = "POST"

     if let params = referralObject {
         urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: ["referral": params.toDictionary()], options: [])
     }

     return apiRequest(urlRequest: &urlRequest, headers: ["Authorization" : bizAuth()], completion: completion, failure: failure)
 }

 }

 //  MARK: Mobile Verification

 extension APIManager {

 @objc internal func verifyRegOTP(phone: String,
                                pin: String,
                                completion: APICompletion<RegistrationResponse>?,
                                failure: APIFailure?) -> URLSessionDataTask {

     let urlString: String = "\(APIManager.baseUrl)/api/v2/card/?customer_phone=\(phone)&pin=\(pin)&nopinsend=true"

     var cs: CharacterSet = CharacterSet.urlQueryAllowed
     cs.remove(charactersIn: "@+")
     let encodedURlString: String = urlString.addingPercentEncoding(withAllowedCharacters: cs)!

     let url: URL = URL(string: encodedURlString)!

     var urlRequest: URLRequest = URLRequest(url: url)

     urlRequest.httpMethod = "POST"

     return apiRequest(urlRequest: &urlRequest, headers: ["Authorization" : bizAuth()], completion: completion, failure: failure)
 }

 @objc internal func resendOTP(phone: String,
                             completion: APICompletion<RegistrationResponse>?,
                             failure: APIFailure?) -> URLSessionDataTask {
     let urlString: String = "\(APIManager.baseUrl)/api/v2/card/?customer_phone=\(phone)&pin=resendotp"

     var cs: CharacterSet = CharacterSet.urlQueryAllowed
     cs.remove(charactersIn: "@+")
     let encodedURlString: String = urlString.addingPercentEncoding(withAllowedCharacters: cs)!

     let url: URL = URL(string: encodedURlString)!

     var urlRequest: URLRequest = URLRequest(url: url)

     urlRequest.httpMethod = "POST"

     return apiRequest(urlRequest: &urlRequest, headers: ["Authorization" : bizAuth()], completion: completion, failure: failure)
 }

 }*/
