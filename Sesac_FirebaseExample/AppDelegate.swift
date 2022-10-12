//
//  AppDelegate.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/06.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIViewController.swizzleMethod()
    
        FirebaseApp.configure()
        
        //원격 알림 시스템에 앱 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        //메세지 대리자 설정
        Messaging.messaging().delegate = self
        
        //등록된 토큰 가져오기
//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token = token {
//                print("FCM registration token: \(token)")
//            }
//        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    //포그라운드 알림 수신, 화면마다 푸시마다 설정할 수도 있음(카카오톡처럼)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Setting화면에 있다면 포그라운드 푸시 띄우지마라
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }

        //세팅화면에서는 알림안뜸
        if viewController is SettingViewController {
            completionHandler([.badge]) //카카오톡처럼 뱃지만. 아무것도 전달할필요가 없을땐 비워놔도됨
        } else {
            completionHandler([.sound, .list, .banner])
        }
        
    }
    //푸시 클릭: 화면 전환같은 것도 가능
    //유저가 푸시를 클릭했을때에만 수신 확인 가능
    //특정 푸시를 클릭하면 특정 상세 화면으로 전환
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("사용자가 푸시를 클릭함")
        
        print(response.notification.request.content.body) // 바디는 알림메세지의 내용
        print(response.notification.request.content.userInfo)// 파이어베이스에서 등록했던 키 밸류
        
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("Petmory")] as? String == "heecheol" {
            print("성공")
        } else {
            print("실패")
        }
        
        //topViewcontroller는 만들어준거
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        print(viewController)
        
        //클래스가 뷰컨트롤러이기만하면 실행되는코드 -> 만들어진 클래스임
        if viewController is ViewController {
            viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
            viewController.navigationController?.pushViewController(SecondViewController(), animated: true)
        }
        if viewController is ProfileViewController {
            viewController.dismiss(animated: true) {
                viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
            }
        }
        if viewController is SettingViewController {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //메세징딜리게이트
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

