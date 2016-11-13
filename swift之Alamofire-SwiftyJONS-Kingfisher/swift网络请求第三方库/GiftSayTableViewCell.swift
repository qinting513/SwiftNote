//
//  GiftSayTableViewCell.swift
//  swift网络请求第三方库
//
//  Created by Qinting on 2016/11/13.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit
import Kingfisher

class GiftSayTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var itemsModel : ItemsModel?{
        didSet{
        
        titleLabel.text = itemsModel?.title
        likeLabel.text = itemsModel?.likecount
        if let url = URL(string: itemsModel?.cover_image_url ?? "") {
            coverImageView.kf.setImage(with: url)
        }
//        coverImageView.kf.setImage(with: itemsModel?.cover_image_url as! Resource?)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
