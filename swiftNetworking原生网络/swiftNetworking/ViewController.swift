//
//  ViewController.swift
//  swiftNetworking
//
//  Created by Qinting on 2016/11/13.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getMethod()
          postMethod()
    }
}

// GET 请求
extension ViewController {
    func getMethod (){
        let url = URL(string: "http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt0-p2-s30-l0.json")
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
    //URLSessionTask负责处理数据的加载以及文件和数据在客户端与服务端之间的上传和下载，NSURLSessionTask 与 NSURLConnection 最大的相似之处在于它也负责数据的加载，最大的不同之处在于所有的 task 共享其创造者 NSURLSession 这一公共委托者（common delegate）
        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if error == nil {
                do {
                    guard  data != nil else{
                       return
                    }
                    let responseDict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments)
                    print("请求结果：" + "\(responseDict)")
                    
                }catch{
                
                }
                
            }
        }
 
        // 启动任务
        task.resume()
    }
}

extension ViewController{
    func postMethod(){
//        注意内容以HTTPBody的方式传递过去
        let request = NSMutableURLRequest(url: NSURL(string: "http://120.25.226.186:32812/login")! as URL)
        // 这块就是区别啦，其实也差不多
        request.httpMethod = "POST"
        let postString = "username=520it&pwd=520it&type=JSON"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest ) { (data, res, error) in
            if error == nil{
                do{
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Post --- > \(responseString)")
                    
                }catch{
                    print("have catch")
                }
            }

        }
        
        task.resume()
//        这个测试接口和参数是我不经意看到的，需要翻墙，才能测试成功
    }

}
