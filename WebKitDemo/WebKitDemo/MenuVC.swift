//
//  MenuVC.swift
//  WebKitDemo
//
//  Created by tarena on 16/1/31.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class MenuVC: UITableViewController {
    
    //数据需要传入
    var items : [Menu] = []
    //用户选择后的回调闭包
    var selectMenuClosure : ((_ menu:Menu)->())?
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        let menu = items[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = menu.title
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[(indexPath as NSIndexPath).row]
        selectMenuClosure?(item)
        self.dismiss(animated: true, completion: nil)
    }
}
