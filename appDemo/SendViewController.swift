//
//  SendViewController.swift
//  appDemo
//
//  Created by Saki Mizuno on 2023/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UserNotifications

// Noticeクラスの定義
struct Notice {
    var id: UUID
    var title: String
    var message: String
    var date: Date
}

class SendViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var sendButton: UIButton!

    @IBAction func noticeSendButton(_ sender: Any) {
        let noticeRef = Firestore.firestore().collection("notice").document()

        // Firestoreに投稿データを保存する
        let noticeDic: [String: Any] = [
            "title": self.titleField.text ?? "",
            "message": self.messageField.text ?? "",
            "date": self.datePicker.date,
        ]

        noticeRef.setData(noticeDic) { error in
            if let error = error {
                print("Error saving notice to Firestore: \(error.localizedDescription)")
            } else {
                let notice = Notice(
                    id: UUID(),  // ランダムなUUIDを生成
                    title: self.titleField.text ?? "",
                    message: self.messageField.text ?? "",
                    date: self.datePicker.date
                )
                self.setNotification(notice: notice)
                // HUDで投稿完了を表示する
                // SVProgressHUD.showSuccess(withStatus: "投稿しました")
                // 投稿処理が完了したので先頭画面に戻る
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    // タスクのローカル通知を登録する
    func setNotification(notice: Notice) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if notice.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = notice.title
        }
        if notice.message == "" {
            content.body = "(内容なし)"
        } else {
            content.body = notice.message
        }
        content.sound = UNNotificationSound.default

        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notice.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: notice.id.uuidString, content: content, trigger: trigger)

        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")
        }

        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
}
