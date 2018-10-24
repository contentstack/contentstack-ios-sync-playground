//
//  APIManager.swift
//  ConferenceApp
//
//  Created by Uttam Ukkoji on 13/08/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

import UIKit
import Contentstack
class StackConfig {
    static var APIKey           = "***REMOVED***"
    static var AccessToken    = "***REMOVED***"
    static var EnvironmentName  = "web"
    static var _config : Config {
        get {
            let config = Config()
            config.host = "stag-cdn.contentstack.io"
            return config
        }
    }
}

enum APIManger {
    
    static var stack : Stack = Contentstack.stack(withAPIKey: StackConfig.APIKey, accessToken: StackConfig.AccessToken, environmentName: StackConfig.EnvironmentName, config:StackConfig._config)
}
