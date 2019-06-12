# RxUserNotifications

[![CI Status](https://img.shields.io/travis/pawelrup/RxUserNotifications.svg?style=flat)](https://travis-ci.org/pawelrup/RxUserNotifications)
[![Version](https://img.shields.io/cocoapods/v/RxUserNotifications.svg?style=flat)](https://cocoapods.org/pods/RxUserNotifications)
[![License](https://img.shields.io/cocoapods/l/RxUserNotifications.svg?style=flat)](https://cocoapods.org/pods/RxUserNotifications)
[![Platform](https://img.shields.io/cocoapods/p/RxUserNotifications.svg?style=flat)](https://cocoapods.org/pods/RxUserNotifications)
[![Xcode](https://img.shields.io/badge/Xcode-11.0-lightgray.svg?style=flat&logo=xcode)](https://itunes.apple.com/pl/app/xcode/id497799835?l=pl&mt=12)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.1-orange.svg?style=flat&logo=swift)](https://swift.org/)

## Requirements

Xcode 11, Swift 5.1

## Installation

### Swift Package Manager

RxAVKit is available through Swift Package Manager. To install it, add the following line to your `Package.swift` into dependencies:
```swift
.package(url: "https://github.com/pawelrup/RxUserNotifications", .upToNextMinor(from: "1.0.0"))
```
and then add `RxAVKit` to your target dependencies.

### CocoaPods

RxUserNotifications is available through [CocoaPods](https://cocoapods.org). To install
it, add the following line to your `Podfile`:

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

Paweł Rup, pawelrup@lobocode.pl

## License

RxUserNotifications is available under the MIT license. See the LICENSE file for more info.
