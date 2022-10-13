//
//  Todo.swift
//  Sesac_FirebaseExample
//
//  Created by HeecheolYoon on 2022/10/13.
//

import RealmSwift

class Todo: Object {
    
    @Persisted var title: String
    @Persisted var favorite: Double
    @Persisted var userDescription: String // title과 favorite을 합침
    @Persisted var count: Int
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, importance: Int) {
        self.init()
        self.title = title
        self.favorite = Double(importance) // 일단 임시적으로 
    }
    
}
