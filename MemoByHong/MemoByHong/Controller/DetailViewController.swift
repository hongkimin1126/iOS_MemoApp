//
//  DetailViewController.swift
//  MemoByHong
//
//  Created by 홍기민 on 2020/07/08.
//  Copyright © 2020 hongkimin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var memo:Memo?
    let textView = UITextView()
    let dateLabel = UILabel()
    
    let dateformatter: DateFormatter = {
        let dateStyle = DateFormatter()
        dateStyle.locale = Locale(identifier: "Ko_kr")
        dateStyle.dateStyle = .long
        dateStyle.timeStyle = .short
        return dateStyle
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let saveButton = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(buttonAction))
        saveButton.tag = 0
        let deleteButton = UIBarButtonItem(title: "delete", style: .done, target: self, action: #selector(buttonAction))
        deleteButton.tag = 1
        navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        setUpUI()
        
        if let memo = self.memo {
            self.title = "메모수정"
            textView.text = memo.content
            dateLabel.text = dateformatter.string(for: memo.insertDate)
        } else {
            self.title = "새 매모"
            
        }
        
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        defer {
            navigationController?.popViewController(animated: true)
        }
        
        if sender.tag == 0 { //저장버튼
            //편집모드와 새메모 작성 모드의 구분
            guard textView.text.count > 0 else {return}
            if let memo = self.memo {
                memo.content = textView.text
                memo.insertDate = Date()
            } else { //새 메모
                MemoData.shared.add(text: textView.text)
            }
            
        } else {// 삭제
            guard let memo = self.memo else {return}
            MemoData.shared.delete(memo: memo)
        }
    }
    
    func setUpUI() {
        view.addSubviews([textView, dateLabel])
        dateLabel.layout.top().centerX()
        textView.layout.leading().trailing().bottom()
        textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        
        
        
    }
}
