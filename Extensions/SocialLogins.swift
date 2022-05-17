//
//  SocialLogins.swift
//  BookKart
//
//  Created by 2022M3 on 08/05/22.
//

import Foundation
//import FBSDKCoreKit
//import FBSDKLoginKit
import AuthenticationServices
import GoogleSignIn

struct SocialLoginDataModel {
    
    init() {
        
    }
    
    var socialId: String!
    var loginType: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var profileImage: String?
}

protocol SocialLoginDelegate: AnyObject {
    func socialLoginData(data: SocialLoginDataModel)
}

class SocialLoginManager: NSObject, GIDSignInDelegate {
    
    //MARK: Class Variable
//    static let shaared: SocialLoginManager = SocialLoginManager()
    weak var delegate: SocialLoginDelegate? = nil
    
    //init
    override init() {
        
    }
}

//MARK: Google Login
extension SocialLoginManager {
    //MARK: Google login methods
    /// Open google login view
    func performGoogleLogin(vc: UIViewController) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
}

//MARK: Google login delegate
extension SocialLoginManager {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            
        } else {
            //Call delegate
            if let delegate = self.delegate {
                
                var dataObj: SocialLoginDataModel = SocialLoginDataModel()
                dataObj.socialId = user.userID
                dataObj.loginType = "G"
                dataObj.firstName = user.profile?.givenName
                dataObj.lastName = user.profile?.familyName
                dataObj.email = user.profile?.email
                //GFunction.shared.firebaseRegister(data: dataObj.email)
                if user.profile!.hasImage {
                    dataObj.profileImage = user.profile?.imageURL(withDimension: 100)?.description
                }
                delegate.socialLoginData(data: dataObj)
            }
        }
    }
}
