//
//  UNUserNotificationCenter+Rx.swift
//  RxUserNotifications
//
//  Created by Pawel Rup on 28.04.2018.
//  Copyright © 2018 Pawel Rup. All rights reserved.
//

import UserNotifications
import RxSwift
import RxCocoa

extension UNUserNotificationCenter: HasDelegate {
	public typealias Delegate = UNUserNotificationCenterDelegate
	
	public typealias DidReceiveResponseCompletionHandler = @convention(block) () -> Void
	public typealias WillPresentNotificationCompletionHandler = @convention(block) (UNNotificationPresentationOptions) -> Void
	
	public typealias DidReceiveResponseArguments = (response: UNNotificationResponse, completion: UNUserNotificationCenter.DidReceiveResponseCompletionHandler)
	public typealias WillPresentNotificationArguments = (notification: UNNotification, completion: UNUserNotificationCenter.WillPresentNotificationCompletionHandler)
}

private class RxUNUserNotificationCenterDelegateProxy: DelegateProxy<UNUserNotificationCenter, UNUserNotificationCenterDelegate>, DelegateProxyType, UNUserNotificationCenterDelegate {
	
	public weak private (set) var controller: UNUserNotificationCenter?
	
	public init(controller: ParentObject) {
		self.controller = controller
		super.init(parentObject: controller, delegateProxy: RxUNUserNotificationCenterDelegateProxy.self)
	}
	
	static func registerKnownImplementations() {
		self.register { RxUNUserNotificationCenterDelegateProxy(controller: $0) }
	}
}

extension Reactive where Base: UNUserNotificationCenter {

	// MARK: - Delegate
	
	public var delegate: DelegateProxy<UNUserNotificationCenter, UNUserNotificationCenterDelegate> {
		return RxUNUserNotificationCenterDelegateProxy.proxy(for: base)
	}
	
	/// Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
	public var willPresentNotification: Observable<UNUserNotificationCenter.WillPresentNotificationArguments> {
		return delegate.methodInvoked(#selector(UNUserNotificationCenterDelegate.userNotificationCenter(_:willPresent:withCompletionHandler:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[2] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: UNUserNotificationCenter.WillPresentNotificationCompletionHandler.self)
				return ($0[1] as! UNNotification, handler)
		}
	}
	
	/// Asks the delegate to process the user's response to a delivered notification.
	public var didReceiveResponse: Observable<UNUserNotificationCenter.DidReceiveResponseArguments> {
		return delegate.methodInvoked(#selector(UNUserNotificationCenterDelegate.userNotificationCenter(_:didReceive:withCompletionHandler:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[2] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: UNUserNotificationCenter.DidReceiveResponseCompletionHandler.self)
				return ($0[1] as! UNNotificationResponse, handler)
		}
	}

	#if os(iOS) || os(macOS)
	/// Asks the delegate to display the in-app notification settings.
	@available(iOS 12.0, macOS 10.14, *)
	public var openSettingsFor: Observable<UNNotification?> {
		return delegate.methodInvoked(#selector(UNUserNotificationCenterDelegate.userNotificationCenter(_:openSettingsFor:)))
			.map { $0[1] as? UNNotification }
	}
	#endif

	// MARK: - Functions

	/// Requests authorization to interact with the user when local and remote notifications are delivered to the user's device.
	public func requestAuthorization(options: UNAuthorizationOptions = []) -> Single<Bool> {
		return Single.create { event -> Disposable in
			self.base.requestAuthorization(options: options) { (success: Bool, error: Error?) in
				if let error = error {
					event(.failure(error))
				} else {
					event(.success(success))
				}
			}
			return Disposables.create()
		}
	}

	/// Retrieves the app’s currently registered notification categories.
	public func getNotificationCategories() -> Single<Set<UNNotificationCategory>> {
		return Single.create { event -> Disposable in
			self.base.getNotificationCategories { (categories: Set<UNNotificationCategory>) in
				event(.success(categories))
			}
			return Disposables.create()
		}
	}

	/// Requests the notification settings for this app.
	public func getNotificationSettings() -> Single<UNNotificationSettings> {
		return Single.create { event -> Disposable in
			self.base.getNotificationSettings { (settings: UNNotificationSettings) in
				event(.success(settings))
			}
			return Disposables.create()
		}
	}

	/// Schedules a local notification for delivery.
	/// - Parameter request: The request object containing the notification payload and trigger information.
	public func add(_ request: UNNotificationRequest) -> Single<Void> {
		return Single.create { event -> Disposable in
			self.base.add(request) { (error: Error?) in
				if let error = error {
					event(.failure(error))
				} else {
					event(.success(()))
				}
			}
			return Disposables.create()
		}
	}

	/// Returns a list of all notification requests that are scheduled and waiting to be delivered.
	public func getPendingNotificationRequests() -> Single<[UNNotificationRequest]> {
		return Single.create { event -> Disposable in
			self.base.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
				event(.success(requests))
			}
			return Disposables.create()
		}
	}

	/// Returns a list of the app’s notifications that are still displayed in Notification Center.
	public func getDeliveredNotifications() -> Single<[UNNotification]> {
		return Single.create { event -> Disposable in
			self.base.getDeliveredNotifications { (requests: [UNNotification]) in
				event(.success(requests))
			}
			return Disposables.create()
		}
	}
}
