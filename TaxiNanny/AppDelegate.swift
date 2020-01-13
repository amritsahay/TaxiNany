//
//  AppDelegate.swift
//  TaxiNanny
//
//  Created by ip-d on 09/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KYDrawerController

import GoogleMaps
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import Stripe
import GooglePlaces
import DropDown

// 1
//let googleApiKey = "AIzaSyCxj7Z3cWeV8phaVuua1cSQ88bWT_ls5u0"
let googleApiKey = "AIzaSyAK5It4p1CiJ2gFzWRbfs24Cibo2QTcPRU"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController:KYDrawerController?
    
    let gcmMessageIDKey = "gcm.message_id"

    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initialization()
        /* let uuid = UUID()
        GoogleAPI.shared.autoComplete(keyword:"SBP HOMES", session: uuid.uuidString) */
      
        // do any other necessary launch configuration
        
        //Notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Thread.sleep(forTimeInterval: 3.0)
        DropDown.startListeningToKeyboard()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Notification
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}

extension AppDelegate
{
    func initialization()
    {
        IQKeyboardManager.shared.enable = true
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleApiKey)
        
        // Set the Google Place API's autocomplete UI control
        GMSPlacesClient.provideAPIKey(googleApiKey)
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        if token != nil {
        
            UserDefaults.standard.set(token, forKey:"fcmtoken")
        }
        else
        {
            UserDefaults.standard.set("", forKey:"fcmtoken")
        }
        
        Messaging.messaging().delegate = self
        //Payment
        STPPaymentConfiguration.shared().publishableKey = "pk_test_TYooMQauvdEDq54NiTphI7jx"
        loadAppStructure()
        CountriesClass.shared
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert,.sound])
    }

}

extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
    
   
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            //test Notification
            
            
        }
        
        // Print full message.
        print(userInfo)
        //test
         //self.NotificationOpenViewController()
        //test
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
}

//MARK:- METHODS 9358406114
extension AppDelegate
{
    //Setting App,s rootView controller
    func loadAppStructure() {
        
        if let string = Constant.readStringUserPreference(Constant.IsAutoLoginEnableKey), !string.isEmpty {
            let value = (Int(Constant.readStringUserPreference(Constant.IsAutoLoginEnableKey)!))
            
            if  ( value == 1)  {
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let leftMenuController =  mainStoryboard.instantiateViewController(withIdentifier:"SlideMenuVC")
                let mainViewController:UINavigationController  = mainStoryboard.instantiateInitialViewController() as! UINavigationController
                var contentController:UIViewController? = nil
                contentController = mainStoryboard.instantiateViewController(withIdentifier:"ParentHomeVC")
                mainViewController.setViewControllers([contentController!], animated:true)
                
                drawerController = KYDrawerController(drawerDirection: .left, drawerWidth:UIScreen.main.bounds.width - UIScreen.main.bounds.width * (15/100))
                drawerController?.screenEdgePanGestureEnabled = false
                drawerController?.mainViewController = mainViewController
                
                drawerController?.drawerViewController = leftMenuController
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = drawerController
                window?.makeKeyAndVisible()
                
            }
            else {
                //login
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let leftMenuController =  mainStoryboard.instantiateViewController(withIdentifier:"SlideMenuVC")
                let mainViewController:UINavigationController  = mainStoryboard.instantiateInitialViewController() as! UINavigationController
                var contentController:UIViewController? = nil
                contentController = mainStoryboard.instantiateViewController(withIdentifier:"TutorialScreenViewController")
                mainViewController.setViewControllers([contentController!], animated:true)
                
                drawerController = KYDrawerController(drawerDirection: .left, drawerWidth:UIScreen.main.bounds.width - UIScreen.main.bounds.width * (15/100))
                drawerController?.screenEdgePanGestureEnabled = false
                drawerController?.mainViewController = mainViewController
                
                drawerController?.drawerViewController = leftMenuController
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = drawerController
                window?.makeKeyAndVisible()
            }
        }
        else{
            
            //login
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let leftMenuController =  mainStoryboard.instantiateViewController(withIdentifier:"SlideMenuVC")
            let mainViewController:UINavigationController  = mainStoryboard.instantiateInitialViewController() as! UINavigationController
            var contentController:UIViewController? = nil
            contentController = mainStoryboard.instantiateViewController(withIdentifier:"TutorialScreenViewController")
            mainViewController.setViewControllers([contentController!], animated:true)
            
            drawerController = KYDrawerController(drawerDirection: .left, drawerWidth:UIScreen.main.bounds.width - UIScreen.main.bounds.width * (15/100))
            drawerController?.screenEdgePanGestureEnabled = false
            drawerController?.mainViewController = mainViewController
            
            drawerController?.drawerViewController = leftMenuController
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = drawerController
            window?.makeKeyAndVisible()
            
        }
    }
    
    func openDrawer(){
        drawerController?.setDrawerState(.opened, animated: true)
    }
    
    //notification
    func NotificationOpenViewController() {
        
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let leftMenuController =  mainStoryboard.instantiateViewController(withIdentifier:"SlideMenuVC")
            let mainViewController:UINavigationController  = mainStoryboard.instantiateInitialViewController() as! UINavigationController
            var contentController:UIViewController? = nil
            contentController = mainStoryboard.instantiateViewController(withIdentifier:"PickupRequestVC")
            mainViewController.setViewControllers([contentController!], animated:true)
        
            drawerController = KYDrawerController(drawerDirection: .left, drawerWidth:UIScreen.main.bounds.width - UIScreen.main.bounds.width * (15/100))
            drawerController?.screenEdgePanGestureEnabled = false
            drawerController?.mainViewController = mainViewController
            
            drawerController?.drawerViewController = leftMenuController
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = drawerController
            window?.makeKeyAndVisible()
    }
    
}
