//
//  GiftSayViewController.swift
//  swift网络请求第三方库
//
//  Created by Qinting on 2016/11/13.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON



class GiftSayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    // 数据源
    var dataArray = [ItemsModel]()
    var giftTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.loadData()
        
    }
    
    func loadData(){
        Alamofire.request("http://api.liwushuo.com/v2/channels/104/items?ad=2&gender=2&generation=2&limit=20&offset=0").responseJSON { (response) in
            
            if let Error = response.result.error{
                print(Error)
            }else if let jsonResult = response.result.value {
            // 用SwiftyJSON 解析数据Dictionary
                let JSONDictionary = JSON(jsonResult)
                let data = JSONDictionary["data"]["items"].array
                for dataDic in data! {
                let model = ItemsModel()
                //  ?? 这个符号，我怕有初学者忘记了的提醒一下，A ?? B  这是一个 NIL合并运算符，它的作用是如果 A 不是NIL 就返回前面可选类型参数 A 的确定值， 如果 A 是NIL 就返回后面 B 的值！A和B之间类型的注意点我就不说了
                    model.cover_image_url = dataDic["cover_image_url"].string ?? ""
                    model.title = dataDic["title"].string ?? ""
                    
                    let numString = String( format:"%d",dataDic["likes_count"].intValue)
                    model.likecount = numString
                    
                    // 数据转模型好后，添加到数组里
                    self.dataArray.append(model)
                }
            }
            self.giftTableView.reloadData()
        }
    }

    func setupUI(){
        let tv = UITableView.init(frame: view.bounds, style: .plain)
        tv.dataSource = self
        tv.delegate = self
//        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.register(UINib.init(nibName: "GiftSayTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        view.addSubview(tv)
        self.giftTableView = tv
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell : GiftSayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GiftSayTableViewCell
            cell.itemsModel = dataArray[indexPath.row]
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
}
