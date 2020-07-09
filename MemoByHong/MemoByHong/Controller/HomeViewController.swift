//
//  HomeViewController.swift
//  MemoByHong
//
//  Created by 홍기민 on 2020/07/08.
//  Copyright © 2020 hongkimin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let tableView = UITableView()
    let dateformatter: DateFormatter = {
        let dateStyle = DateFormatter()
        dateStyle.locale = Locale(identifier: "Ko_kr")
        dateStyle.dateStyle = .long
        dateStyle.timeStyle = .short
        return dateStyle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "메모장"
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        MemoData.shared.fetchMemo()
        let addbutton = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addMemo))
        navigationItem.rightBarButtonItem = addbutton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    
    @objc func addMemo(_ sender: UIBarButtonItem) {
        let dvc = DetailViewController()
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return MemoData.shared.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusecell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = reusecell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = MemoData.shared.memoList[indexPath.row].content
        // 날짜는 DateFormatter사용
        cell.detailTextLabel?.text = dateformatter.string(for: MemoData.shared.memoList[indexPath.row].insertDate)
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    //클릭시 DetailViewController로 화면전환
    //delet 기능 구현
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.memo = MemoData.shared.memoList[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //알러트 한번 띄워서 확인받기
            //코어데이터에서 지우고 메모리스트에서도 지우기
            let alert = UIAlertController(title: "삭제확인", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let action = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                MemoData.shared.delete(memo: MemoData.shared.memoList[indexPath.row])
                MemoData.shared.memoList.remove(at: indexPath.row)
                self.tableView.reloadData()
                }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(action)
            alert.addAction(cancelAction)
        }
    }
}
