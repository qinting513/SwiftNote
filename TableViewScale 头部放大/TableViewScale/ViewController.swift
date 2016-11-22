//
//  ViewController.swift
//  TableViewScale
//
//  Created by Qinting on 2016/11/15.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let UISCreen_Width = UIScreen.main.bounds.size.width
    let UISCreen_Height = UIScreen.main.bounds.size.height
    let imageHeight:CGFloat = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.addSubview(headImageView)
         headImageView.addSubview(headView)
    }
  
//    懒加载一个tableview，一个imageView。tableView需要设置它的contentInset。
   private lazy var tableView:UITableView = {
        let frame = CGRect(x: 0, y: 0, width: self.UISCreen_Width, height: self.UISCreen_Height)
        let tableView = UITableView.init(frame: frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(UITableView.self, forCellReuseIdentifier: "UITableView")
        tableView.contentInset = UIEdgeInsetsMake(self.imageHeight, 0, 0, 0)
    
        return tableView
    }()
    
     lazy var headImageView : UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: -self.imageHeight, width: self.UISCreen_Width, height: self.imageHeight))
        imageView.image = UIImage.init(named: "2.jpg")
        return imageView
    }()
    
    lazy var headView:UIView = {
        let headV = UIView.init(frame: CGRect(x: self.headImageView.frame.size.width*0.5,
                                              y: self.headImageView.frame.size.height - 20, width: 30, height: 30))
        headV.backgroundColor = UIColor.blue
        return headV
    }()
}

extension ViewController : UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
        }
        cell?.textLabel?.text = "indenxPath.row = \(indexPath.row)"
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension ViewController {
    /**
     * UIScrollView的代理方法，监听tableview的偏移量
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentossetX = (contentOffsetY + self.imageHeight) / 2.0
        if contentOffsetY < -self.imageHeight {
            var rect = headImageView.frame
            rect.origin.y = contentOffsetY
            rect.origin.x = contentossetX
            rect.size.height = -contentOffsetY
            // 因为向2边扩散，所以要乘以2
            rect.size.width = self.UISCreen_Width + fabs(contentossetX) * 2
            headImageView.frame = rect
        }
    }

}
