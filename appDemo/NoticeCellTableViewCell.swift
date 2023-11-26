//
//  NoticeCellTableViewCell.swift
//  appDemo
//
//  Created by Saki Mizuno on 2023/11/25.
//

import UIKit

class NoticeCellTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var noticeImageView: UIImageView!
    @IBOutlet weak var noticeTitleLabel: UILabel!
    @IBOutlet weak var noticeMessageLabel: UILabel!
    @IBOutlet weak var noticeDateLabel: UILabel!
    
    func setNoticeData(_ noticeData: NoticeData) {
        // 画像の表示
//        noticeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(noticeData.id + ".jpg")
//        noticeImageView.sd_setImage(with: imageRef)

        // タイトルの表示
        self.noticeTitleLabel.text = "\(noticeData.title)"

        // 本文の表示
        self.noticeMessageLabel.text = "\(noticeData.message)"

        // 日時の表示
        self.noticeDateLabel.text = noticeData.date
    }
    
    
}
