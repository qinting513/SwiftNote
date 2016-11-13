//
//  ViewController.swift
//  QTRefreshViewControl
//
//  Created by Qinting on 2016/11/13.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {

    var allCities : [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
       allCities = loadData() as? [String]
        setupUI()
    }
  
    func setupUI(){
    let tv = UITableView.init(frame: view.bounds, style: .plain)
        tv.dataSource = self
        view.addSubview(tv)
//         tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
     let refreshView = RefreshView.init(frame: CGRect(x: 0, y: -60, width: UIScreen.main.bounds.size.width, height: 60))
        refreshView.backgroundColor = UIColor.brown
        tv.addSubview(refreshView)
        refreshView.beginRefresh {
          
            
            DispatchQueue.global().async {
                print("开始执行异步任务")
               
                Thread.sleep(forTimeInterval: 3)
                print("异步任务执行完毕")
                let arrM = NSMutableArray()
                arrM.addObjects(from: self.loadData())
                arrM.addObjects(from: self.allCities!)
                self.allCities = arrM as? [String]
                DispatchQueue.main.async {
                    tv.reloadData()
                    print("回到UI线程")
                     refreshView.endrefresh()
                }
            }
        }
        
    }
    
    func loadData() -> [AnyObject]{
        let arrM  = NSMutableArray()
       for i in 0..<3 {
            let str = "测试数据" + String(i)
            arrM.add(str)
        }
//        print(arrM);
        return arrM  as [AnyObject] ;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (allCities?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        }
        
        if let str = allCities?[indexPath.row] {
            cell?.textLabel?.text = str
        }
        
        return cell!
    }
}


