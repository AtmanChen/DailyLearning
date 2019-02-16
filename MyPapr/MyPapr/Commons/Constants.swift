//
//  Constants.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework


struct Constants {
    
    static let photosPerPage = 10
    
    struct Appearance {
        struct Color {
            static let iron = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
            static let yellowZ = UIColor(red: 252.0/255.0, green: 197.0/255.0, blue: 6.0/255.0, alpha: 1.0)
        }
        struct Style {
            static let imageCornerRadius: CGFloat = 8.0
        }
    }
    
    struct UnsplashSettings {
        static let host = "unsplash.com"
        static let callbackURLScheme = "papr://"
        static let clientID = UnsplashSecrets.clientID
        static let clientSecret = UnsplashSecrets.clientSecret
        static let authorizeURL = "https://unsplash.com/oauth/authorize"
        static let tokenURL = "https://unsplash.com/oauth/token"
        static let redirectURL = "papr://unsplash"
        
        
        
        private struct UnsplashSecrets {
            static let clientID = UnsplashSecrets.environmentVariable(named: "UNSPLASH_CLIENT_ID") ?? ""
            static let clientSecret = UnsplashSecrets.environmentVariable(named: "UNSPLASH_CLIENT_SECRET") ?? ""
            
            
            private static func environmentVariable(named: String) -> String? {
                guard let infoDictionary = Bundle.main.infoDictionary,
                    let value = infoDictionary[named] as? String else {
                        return nil
                }
                return value
            }
        }
    }
}
