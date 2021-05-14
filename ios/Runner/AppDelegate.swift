import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA6dBckc7dPdoIxpCInR39ppxc9INtFPGw")
    GeneratedPluginRegistrant.register(with: self)
    
    let view_bill = UNNotificationAction(identifier: "view_bill", title: "View Bill", options: [.foreground])
    let keep_open = UNNotificationAction(identifier: "keep_open", title: "Keep Open", options: [])
    let pay = UNNotificationAction(identifier: "pay", title: "Pay", options: [])
    let call_business = UNNotificationAction(identifier: "call", title: "Call Business", options: [.foreground])
    
    let auto_pay_category = UNNotificationCategory(identifier: "auto_paid", actions: [view_bill], intentIdentifiers: [], options: .customDismissAction)
    let bill_closed_category = UNNotificationCategory(identifier: "bill_closed", actions: [view_bill, pay], intentIdentifiers: [], options: .customDismissAction)
    let exit_category = UNNotificationCategory(identifier: "exit", actions: [view_bill, keep_open, pay], intentIdentifiers: [], options: .customDismissAction)
    let fix_bill_category = UNNotificationCategory(identifier: "fix_bill", actions: [view_bill, pay, call_business], intentIdentifiers: [], options: .customDismissAction)
    
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.setNotificationCategories([auto_pay_category, bill_closed_category, exit_category, fix_bill_category])
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
