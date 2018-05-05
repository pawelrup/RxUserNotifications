# RxUserNotifications

[![CI Status](https://img.shields.io/travis/pawelrup/RxUserNotifications.svg?style=flat)](https://travis-ci.org/pawelrup/RxUserNotifications)
[![Version](https://img.shields.io/cocoapods/v/RxUserNotifications.svg?style=flat)](https://cocoapods.org/pods/RxUserNotifications)
[![License](https://img.shields.io/cocoapods/l/RxUserNotifications.svg?style=flat)](https://cocoapods.org/pods/RxUserNotifications)
[![Platform](https://img.shields.io/cocoapods/p/RxUserNotifications.svg?style=flat)](https://cocoapods.org/pods/RxUserNotifications)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Xcode 9, Swift 4.1

## Installation

RxUserNotifications is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxUserNotifications'
```

## Usage

Simply subscribe to `willPresentNotification` or `didReceiveResponse` like below:

```swift
let center = UNUserNotificationCenter.current()

// Presenting notification when app is in foreground.

center.rx.willPresentNotification
	.subscribe(onNext: { (notification: UNNotification, completion: UNUserNotificationCenter.WillPresentNotificationCompletionHandler) in
		// Do something
		completion([.badge, .alert, .sound])
	})
	.disposed(by: disposeBag)

// Receiving user response

center.rx.didReceiveResponse
	.subscribe(onNext: { (response: UNNotificationResponse, completion: UNUserNotificationCenter.DidReceiveResponseCompletionHandler) in
		// Do something
		completion()
	})
	.disposed(by: disposeBag)
```

## Author

lobocode, pawelrup@lobocode.pl

## License

RxUserNotifications is available under the MIT license. See the LICENSE file for more info.
