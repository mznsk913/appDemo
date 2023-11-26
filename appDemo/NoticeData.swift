//
//  NoticeData.swift
//  appDemo
//
//  Created by Saki Mizuno on 2023/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NoticeData: NSObject {
    var id = ""
    var name = ""
    var title = ""
    var message = ""
    var date = ""

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()

        if let name = postDic["name"] as? String {
            self.name = name
        }

        if let title = postDic["title"] as? String {
            self.title = title
        }
        
        if let message = postDic["message"] as? String {
            self.message = message
        }

        if let timestamp = postDic["date"] as? Timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.date = formatter.string(from: timestamp.dateValue())
        }
    }
}
