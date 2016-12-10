//
//  ConfigDefaultHeaderFooterController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/13.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

class ConfigDefaultHeaderFooterController: UITableViewController {
    var models = [1,2,3,4,5,6,7,8,9,10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Header
        _ = self.tableView.setUpHeaderRefresh { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(.success,delay: 0.3)
            })
        }.SetUp { (header) in
            header.setText("Pull to refresh", mode: .pullToRefresh)
            header.setText("Release to refresh", mode: .releaseToRefresh)
            header.setText("Success", mode: .refreshSuccess)
            header.setText("Refreshing...", mode: .refreshing)
            header.setText("Failed", mode: .refreshFailure)
            header.textLabel.textColor = UIColor.orange
            header.durationWhenHide = 0.4
        }
        //Footer
        
        _ = self.tableView.setUpFooterRefresh {  [weak self] in
            delay(1.5, closure: {
                self?.models.append(random100())
                self?.tableView.reloadData()
                self?.tableView.endFooterRefreshing()
            })
        }.SetUp { (footer) in
            footer.setText("Pull up to refresh", mode: RefreshKitFooterText.pullToRefresh)
            footer.setText("No data any more", mode: RefreshKitFooterText.noMoreData)
            footer.setText("Refreshing...", mode: RefreshKitFooterText.refreshing)
            footer.setText("Tap to load more", mode: RefreshKitFooterText.tapToRefresh)
            footer.textLabel.textColor  = UIColor.orange
            footer.refreshMode = .tap
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(models[(indexPath as NSIndexPath).row])"
        return cell!
    }
    deinit{
        print("Deinit of DefaultTableViewController")
    }

}
