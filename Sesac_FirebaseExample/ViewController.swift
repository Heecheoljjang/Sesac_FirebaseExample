//
//  ViewController.swift
//  Sesac_FirebaseExample
//
//  Created by HeecheolYoon on 2022/10/05.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        Analytics.logEvent("test", parameters: [
//            "name": "ㅎ흐히ㅓㅣ",
//          "full_text": "full",
//        ])
//        Analytics.setDefaultEventParameters([
//          "level_name": "Caverns01",
//          "level_difficulty": 4
//        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ViewController ViewWillAppear")
    }
    
    @IBAction func crashCldicked(_ sender: UIButton) {
        
    }
    @IBAction func profileButtonClicked(_ sender: UIButton) {
        present(ProfileViewController(), animated: true)
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
}

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ProfileController ViewWillAppear")
    }
}

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SettingController ViewWillAppear")
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SecondController ViewWillAppear")
    }
}



extension UIViewController {
    
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    //최상위 뷰컨트롤러를 판단해주는 메서드
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        
        //타입캐스팅이 되는지 확인해서 된다면 탭바 컨트롤러와 연결되어있는 루트뷰컨트롤러를 가져오면됨
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            
            
            return self.topViewController(currentViewController: selectedViewController)
        } else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            
            
            return self.topViewController(currentViewController: visibleViewController)
        } else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewController(currentViewController: presentedViewController)
        } else {
            return currentViewController
        }
        
    }
    
}

extension UIViewController {
    
    class func swizzleMethod() {
        
        let origin = #selector(viewWillAppear)
        let change = #selector(changeViewWillAppear)
        
        //메서드가 있는지 확인
        guard let originMethod = class_getInstanceMethod(UIViewController.self, origin), let changeMethod = class_getInstanceMethod(UIViewController.self, change) else {
            print("함수를 찾을 수 없음")
            return
        }
        method_exchangeImplementations(originMethod, changeMethod)
    }
    
    @objc func changeViewWillAppear() {
        print("changeViewWillAppear로 바뀜")
    }
    
}
