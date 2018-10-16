//
//  AppDelegate.swift
//  RxUserNotifications
//
//  Created by pawelrup on 04/30/2018.
//  Copyright (c) 2018 pawelrup. All rights reserved.
//

import UIKit
import UserNotifications
import RxSwift
import RxUserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	let disposeBag = DisposeBag()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		UNUserNotificationCenter.current().rx
			.requestAuthorization(options: [.sound, .badge, .alert])
			.subscribe(onSuccess: { (_: Bool) in
				UIApplication.shared.registerForRemoteNotifications()
			}, onError: { (error: Error) in
				print(String(describing: error.localizedDescription))
			})
			.disposed(by: disposeBag)
		
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
