//
//  NoticeViewController.swift
//  appDemo
//
//  Created by Saki Mizuno on 2023/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
//import Foundation

class NoticeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // カスタムセルを登録する
        let nib = UINib(nibName: "NoticeCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    // 通知データを格納する配列
    var noticeArray: [NoticeData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
            let noticeRef = Firestore.firestore().collection(Const.NoticePath).order(by: "date", descending: true)
            listener = noticeRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.noticeArray = querySnapshot!.documents.map { document in
                    let noticeData = NoticeData(document: document)
                    print("DEBUG_PRINT: \(noticeData)")
                    return noticeData
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeCellTableViewCell
        cell.setNoticeData(noticeArray[indexPath.row])

        return cell

    }
    
}
