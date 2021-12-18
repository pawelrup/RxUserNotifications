//
//  UNNotificationServiceExtension+Rx.swift
//  RxUserNotifications
//
//  Created by Pawel Rup on 12/06/2019.
//

import UserNotifications
import RxSwift
import RxCocoa

@available(iOS 10.0, watchOS 6.0, macOS 10.14, *)
extension UNNotificationServiceExtension {
  static var rx: RxStatic.Type {
    RxStatic.self
  }

  struct RxStatic {}
}

@available(iOS 10.0, watchOS 6.0, macOS 10.14, *)
extension UNNotificationServiceExtension.RxStatic {

	/// Asks you to make any needed changes to the notification and notify the system when you're done.
	/// - Parameter request: The original notification request. Use this object to get the original content of the notification.
	public func didReceive(_ request: UNNotificationRequest) -> Single<UNNotificationContent> {
		return Single.create { event -> Disposable in
			self.base.didReceive(request) { (notificationContent: UNNotificationContent) in
				event(.success(notificationContent))
			}
			return Disposables.create()
		}
	}
}
