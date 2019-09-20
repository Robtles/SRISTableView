//
//  AppDelegate.swift
//  Example
//
//  Created by Rob on 20/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import Parse
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Uncomment this line to use Parse API
        /// You'll need to set your keys and information
        //self.initParseAPI()
        return true
    }
    
    private func initParseAPI() {
        let applicationId = "{your_application_id}"
        let clientKey = "{your_client_key}"
        let server = "{your_server_url}"
        Parse.initialize(with: ParseClientConfiguration() {
            $0.applicationId = applicationId
            $0.clientKey = clientKey
            $0.server = server
            $0.isLocalDatastoreEnabled = true
        })
    }
    
}
