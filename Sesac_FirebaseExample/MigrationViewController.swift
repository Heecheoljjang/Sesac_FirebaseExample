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
        //
        //        for i in 1...10 {
        //            let task = DetailTodo(detailTitle: "\(i)개 사기", favorite: true)
        //
        //            try! localRealm.write {
        //                localRealm.add(task)
        //            }
        //        }
        
        //특정 Todo 테이블에 DetailTodo 추가
        //        guard let task = localRealm.objects(Todo.self).filter("title = '안녕하세요 8'").first else { return }
        //
        //        let detail = DetailTodo(detailTitle: "안녕히계세요", favorite: false)
        //
        //        try! localRealm.write {
        //            task.detail.append(detail)
        //        }
        
        //특정 Todo 테이블에 DetailTodo 여러개추가
        //        guard let task = localRealm.objects(Todo.self).filter("title = '안녕하세요 1'").first else { return }
        //
        //        let detail = DetailTodo(detailTitle: "오오오오옹 \(Int.random(in: 1...5))", favorite: false)
        //
        //        for _ in 1...10 {
        //            try! localRealm.write {
        //                task.detail.append(detail)
        //            }
        //        }
        
        //특정 Todo 테이블 삭제
        //        guard let task = localRealm.objects(Todo.self).filter("title = '안녕하세요 1'").first else { return }
        //
        //        try! localRealm.write {
        //            localRealm.delete(task.detail)
        //            localRealm.delete(task)
        //        }
        
        //특정 Todo에 메모 추가(임베디드 오브젝트)
        guard let task = localRealm.objects(Todo.self).filter("title = '안녕하세요 2'").first else { return }
        
        let memo = Memo()
        memo.content = "메모 추가"
        memo.date = Date()
        
        try! localRealm.write {
            task.memo = memo
        }
    }
    
}
