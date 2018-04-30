//
//  ViewController.swift
//  RxUserNotifications
//
//  Created by pawelrup on 04/30/2018.
//  Copyright (c) 2018 pawelrup. All rights reserved.
//

import UIKit
import UserNotifications
import RxSwift
import RxSwiftExt
import RxUserNotifications

class ViewController: UIViewController {
	
	private typealias TextInputNotificationResponseArguments = (response: UNTextInputNotificationResponse, completion: UNUserNotificationCenter.DidReceiveResponseCompletionHandler)
	
	let disposeBag = DisposeBag()
	let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		center.rx.didReceiveResponse
			.filterMap { (arg: UNUserNotificationCenter.DidReceiveResponseArguments) -> FilterMap<TextInputNotificationResponseArguments> in
				if let response = arg.response as? UNTextInputNotificationResponse {
					return .map((response, arg.completion))
				}
				return .ignore
			}
			.filter { $0.0.actionIdentifier == "inline-reply-action" }
			.subscribe(onNext: {
				print($0.0.userText)
				$0.1()
			})
			.disposed(by: disposeBag)
    }
	
	private func createCategories() {
		let inlineReplyCategory = makeInlineReplyCategory()
		center.setNotificationCategories([inlineReplyCategory])
	}
	
	private func makeInlineReplyCategory() -> UNNotificationCategory {
		let inlineReplyAction = UNTextInputNotificationAction(identifier: "inline-reply-action",
															  title: "Hey! Say Something!",
															  options: UNNotificationActionOptions(rawValue: 0),
															  textInputButtonTitle: "Send text",
															  textInputPlaceholder: "Reply…")
		let inlineReplyCategory = UNNotificationCategory(identifier: "MESSAGE_CATEGORY",
														 actions: [inlineReplyAction],
														 intentIdentifiers: [],
														 options: [])
		return inlineReplyCategory
	}
	
	func sendTestInlineReplyPush() {
		let content = UNMutableNotificationContent()
		content.title = "Testing inline reply notificaions on iOS 10"
		content.body = "Wow it works!"
		content.sound = UNNotificationSound.default()
		content.categoryIdentifier = "MESSAGE_CATEGORY"
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		
		let identifier = "RxLocalNotification"
		let request = UNNotificationRequest(identifier: identifier,
											content: content,
											trigger: trigger)
		UNUserNotificationCenter
			.current()
			.add(request)
	}
}
