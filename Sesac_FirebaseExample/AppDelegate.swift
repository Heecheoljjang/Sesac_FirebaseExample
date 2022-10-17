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
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = Realm.Configuration(schemaVersion: 3) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
                //DetailTodo, List 추가
            }
            if oldSchemaVersion < 2 {
                //EmbeddedObject 추가
            }
            if oldSchemaVersion < 3 {
                //DetailTodo deadline컬럼 추가
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        //aboutRealmMigration()
        
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

extension AppDelegate {
    
    func aboutRealmMigration() {
        
        //deleteRealmIfMirgrationNeeded: 마이그레이션이 필요한 경우 기존 렘 삭제. 스키마 버전 0부터 삭제
        //출시할때는 없애고 해야함
        //Realm studio 닫고 빌드해야함
        //스키마 버전에는 가장 최신버전 -> 근데 임의로 높은 숫자 넣으면 그 버전으로 바뀜
        //별도로 설정하지않으면 0부터 1씩 늘어나면서 증가함
        //중간에 건너뛴 버전을 사용할 순 없음
        //그래서 따로 만지지않는다면 스키마 버전은 마이그레이션 한 횟수랑 같아질거임
        //let config = Realm.Configuration(schemaVersion: 4, deleteRealmIfMigrationNeeded: true)
        
        //모든 버전에 대한 대응. 차례대로 해야하므로 else if를 사용하면 조건문중에서 하나만 실행하고 나머지 건너뛰므로 마이그레이션과는 맞지않음
        //컬럼에 들어가는 내용이 없으면 비워도도 괜찮음
        //스키마 버전 확실히 확인하기

        let config = Realm.Configuration(schemaVersion: 9) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 { //어떤 컬럼 추가, 어떤 컬럼 삭제 등 주석으로 남겨도되고, 깃에 대한 커밋으로 남겨도 될듯. 아니면 명시적으로 enumerateObject코드를 이용해서 새로운 컬럼에 nil같이 값을 넣어줄 순 있는데 굳이 그럴필요는 없을듯.

            }
            if oldSchemaVersion < 2 {

            }
            if oldSchemaVersion < 3 {

            }
            if oldSchemaVersion < 4 {
                
            }
            if oldSchemaVersion < 5 {
                //컬럼의 이름 변경
                migration.renameProperty(onType: Todo.className(), from: "importance", to: "favorite")
            }
            if oldSchemaVersion < 6 {
                // 두 컬럼을 하나로
                // 데이터를 넣지 않는다면( 컬럼 단순 추가 삭제의 경우) 별도 코드 필요 x
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    
                    guard let new = newObject, let old = oldObject else { return }
                    new["userDescription"] = "하이하이 \(old["title"])는 타이틀, 뻬이보릿은 \(old["favorite"])"
//                    new["userDescription"] = "초기값" // 기존의 컬럼 데이터를 사용하지않고 직접 초기값 설정 가능
                    
                }
            }
            if oldSchemaVersion < 7 {
                //count를 추가하고 초기값으로 100을 넣음. 꼭 old, new 다 써야하는건아님
                migration.enumerateObjects(ofType: Todo.className()) { _ , newObject in
                    
                    guard let new = newObject else { return }
                    new["count"] = 100
                    
                }
            }
            if oldSchemaVersion < 8 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    guard let new = newObject, let old = oldObject else { return }
                    
                    new["favorite"] = old["favorite"] //원래 형변환 필요한데 인트에서 더블이므로 반드시 성공하기때문에 따로 안함. 또한 둘 다 옵셔널이 아니므로 이렇게만 해도 가능
                    
                    //이렇게도 가능. 타입캐스팅해야함
//
//                    if old["favorite"] < 4 {
//                        new["favorite"] = 5.5
//                    }
                    
                    //기존의 값인 nil인 경우에는 기본값을 줘야함
//                    new["favorite"] = old["favorite"] ?? 4.4
                }
            }
            //옵셔널없앰
            if oldSchemaVersion < 9 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    guard let new = newObject, let old = oldObject else { return }
                    
                    new["title"] = old["title"]
                    new["userDescription"] = old["userDescription"]
                }
            }
        }

        Realm.Configuration.defaultConfiguration = config

    }
    
}
