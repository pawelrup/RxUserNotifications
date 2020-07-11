Pod::Spec.new do |s|
  s.name             = 'RxUserNotifications'
  s.version          = '1.1.0'
  s.summary          = 'Reactive extension for UserNotifications.'

  s.description      = <<-DESC
  RxUserNotifications is an RxSwift reactive extension for UNUserNotificationCenter.
  Requires Xcode 12.0 with Swift 5.3 or greather.
                       DESC

  s.homepage         = 'https://github.com/pawelrup/RxUserNotifications'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paweł Rup' => 'pawelrup@lobocode.pl' }
  s.source           = { :git => 'https://github.com/pawelrup/RxUserNotifications.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
  s.macos.deployment_target = '10.14'

  s.swift_version = '5.3'

  s.source_files = 'Sources/RxUserNotifications/**/*'

  s.frameworks = 'UserNotifications'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
