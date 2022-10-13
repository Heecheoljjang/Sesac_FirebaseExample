//
//  MigrationViewController.swift
//  Sesac_FirebaseExample
//
//  Created by HeecheolYoon on 2022/10/13.
//

import UIKit
import RealmSwift

class MigrationViewController: UIViewController {
    
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. fileURL
        print("FileURL: \(localRealm.configuration.fileURL!)")
        
        //2. 스키마버전 확인하는 코드
        do {
            let version = try schemaVersionAtURL(localRealm.configuration.fileURL!)
            print("Schema Version: \(version)")
                
        } catch {
            print("오류")
        }
        
        //3. Test
//        for i in 0...100 {
//            let task = Todo(title: "안녕하세요 \(i)", importance: Int.random(in: 1...5))
//            
//            do {
//                try localRealm.write {
//                    localRealm.add(task)
//                }
//            } catch {
//                print("추가 오류")
//            }
//        }
    }
    
}
