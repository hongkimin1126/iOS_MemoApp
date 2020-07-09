//
//  MemoData.swift
//  MemoByHong
//
//  Created by 홍기민 on 2020/07/08.
//  Copyright © 2020 hongkimin. All rights reserved.
//

import Foundation
import CoreData

class MemoData {
    static let shared = MemoData()
    var memoList: [Memo] = []
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //fetch: 메모 데이터 불러오기.
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        let sorting = NSSortDescriptor(key: "insertDate", ascending: false)//false -> 내림차순정렬
        request.sortDescriptors = [sorting]
        
        //fetch 한후 담을 배열을 밖에 만들기.
        do {
           memoList = try mainContext.fetch(request)
            } catch  {
            fatalError()
        }
    }
    
    //add: 메모추가하기
    //Memo 인스턴스생성하기
    //content와 insertData 넣고 memoList에도 넣는다
    //저장
    func add(text: String) {
        let newMemo = Memo(context: mainContext)
        newMemo.content = text
        newMemo.insertDate = Date()
        memoList.insert(newMemo, at: 0) //최신화 효과
        saveContext()
    }
    
    //delete: 메모삭제
    func delete(memo: Memo) {
        mainContext.delete(memo)
        saveContext()
    }
    
    
    
    
    
    // MARK: - Core Data Saving support
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "MemoByHong")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
           
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
