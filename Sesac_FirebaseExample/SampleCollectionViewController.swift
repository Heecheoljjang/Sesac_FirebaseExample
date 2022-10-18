//
//  SampleCollectionViewController.swift
//  Sesac_FirebaseExample
//
//  Created by HeecheolYoon on 2022/10/18.
//

import UIKit
import RealmSwift

class SampleCollectionViewController: UICollectionViewController {

    var tasks: Results<Todo>!
    let localRealm = try! Realm()
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let tv = UITableView()
//        tv.delegate = self //셀프는 클래스의 인스턴스. 딜리게이트는 UITableViewDelegate라는 프로토콜을 타입으로 갖는 프로퍼티임. 그래서 프로토콜인데 다른 클래스 인스턴스를 넣을 수 있었던 이유가 아래에서 과일로 했던거랑 같으 ㄴ이유임
//        tv.dataSource = self
        
        
        
        tasks = localRealm.objects(Todo.self)
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration) //정해져있는 레이아웃으로 나오게됨
        collectionView.collectionViewLayout = layout // UICollectionViewLayout기반으로 만들어져있기때문에 같은 타입으로 사용이 가능함
        
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()
            content.image = itemIdentifier.importance < 2 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)" //detail은 List타입이기때문에 배열일 것임
            
            cell.contentConfiguration = content //UIContentConfiguration인데 실제로 넣는 content는 UIListContentConfiguration인데 아까와 달리 프로토콜 타입을 활용했기때문에 값이 동일하게 넣을 수 있는 것임 뭔말임
            // UIContentConfiguration은 프로토콜이고 content는 UIListContetnConfiguration 구조체인데 프로토콜로 UIContentConfiguration을 채택하기 때문에 넣을 수 있었던거임
        })

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tasks[indexPath.item]
        
        //셀을 재사용하되 cellRegistration 활용. 재사용하는 메서드와 데이터 다루는 cellRegistration으로 나눠진 느낌
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)

//        var test: fruit = apple() //애플 클래스 인스턴스
//        test = banana() // 이렇게하면 타입이 다르기때문에 못넣음. 근데 애플과 바나나를 전부 food를 상속받게하고 test의 타입을 food로 하면 가능. 즉, 클래스간 상속만 잘해줘도 대입 가능
//        test = melon() // 구조체이기 때문에 상속도 불가능함. 프로토콜을 채택하고 test의 타입을 프로토콜로 하면 프로토콜을 채택한 것들은 전부 대입할 수 있음
        return cell
    }
}
//
//class food {
//    //부모클래스
//}
//
//protocol fruit {
//
//}
//
////애플이랑 바나나에 상속
//class apple: food, fruit{
//
//}
//
//class banana: food, fruit {
//
//}
//
////열거형도 상속 불가
//enum strawberry: fruit {
//
//}
//
////멜로이 구조체인 경우엔 상속불가
//struct melon: fruit {
//
//}
