//
//  AppDelegate.swift
//  RxUserNotifications
//
//  Created by pawelrup on 04/30/2018.
//  Copyright (c) 2018 pawelrup. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { [application] (granted, error) in
			DispatchQueue.main.async {
				if granted {
					application.registerForRemoteNotifications()
				} else {
					print(String(describing: error?.localizedDescription))
				}
			}
		}
        return true
    }
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let token = deviceToken.map { String(format: "%02x", $0) }.joined()
		print("Push device token:", token)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print(#function, error.localizedDescription)
	}
}
