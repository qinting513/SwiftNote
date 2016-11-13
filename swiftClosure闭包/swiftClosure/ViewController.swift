//
//  ViewController.swift
//  swiftClosure
//
//  Created by Qinting on 2016/11/13.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit

//http://www.open-open.com/lib/view/open1474524707276.html

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //定义一个求和闭包
        let addBlock:(Int,Int)->(Int) = { (a,b) in
            return a + b
        }
        //执行闭包，相当于调用函数
        var result = addBlock(100, 200)
        //打印闭包返回值
        print("result=\(result)")
        
        // =========================================
        //可以用关键字“typealias”先声明一个闭包的数据类型
        typealias mulBlock = (Int,Int)->(Int);
        let mul : mulBlock = {(a,b) in
            return a - b  // 闭包体
        }
        result = mul(100,90)
        print("result=\(result)")
        
        // =========================================
        /*
         ios中类之间的通信方式有多种，常用的有：协议代理、通知，以及本章要讲的闭包。因为协议代理用起来比较麻烦，又是声明协议方法、又要设置代理的，代码步骤太多，我一般不用；通知一般用于两个完全没有关联的类通信，可以一对多，但解耦和的太厉害，我一般是特定的场合用。所以针对有关联的两个类之间的通信，我一般是用闭包或block的，这样比较简洁迅速
         */
        setupUI()
    }
}

//1、两个类之间的通信
extension ViewController {
    func setupUI() {
    let customView = CustomView.init(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
    self.view .addSubview(customView)
        customView.backgroundColor = UIColor.yellow
         //给cutomeView的btnClickBlock闭包属性赋值
        customView.btnClickBlock = {
            // () in 无参数可以省略
            //当按钮被点击时会执行此代码块
            print("按钮被点击");
            
            self.requestData(urlString: "http:www.baidu.com", succeed: { (data) -> (Void) in
                //成功的回调
                guard let result = data as? Data else{
                    return
                }
                let str = NSString(data: result, encoding: String.Encoding.utf8.rawValue)
                    print(str!)
                
                }, failure: { (error) -> (Void) in
                    //失败的的回调
                   print("============= error:" + "\(error)" )
            })
        }
    }
}

//2、异步回调（callBack）
extension ViewController {
    
    func requestData(urlString:String,succeed:((Any?)->(Void))?,failure:((Any?)->(Void))?){
        guard urlString.lengthOfBytes(using: .utf8) > 0 else {
            return;
        }
        let request = URLRequest(url: URL(string: urlString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue()) { (_, data, error) in
            if error == nil {
            // //请求成功，执行成功的回调，并把数据传递出去
                succeed?(data)
            }else{
             //请求失败，执行失败的回调，并把错误传递出去
                failure?(error)
            }
        }
        
    }

}

//3.闭包的一些特殊用法 -- 尾随闭包
extension ViewController {

//    当闭包作为函数的最后一个参数时，可以省略前面的括号。尾随闭包没什么特殊的作用，纯粹是一种语法上的简洁，增加易读性。
    func post(url:String,success:(String)->Void ){
        print("发来请求")
        success("请求完成")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //正常写法，第二个参数，传递一个闭包
        post(url: "http", success: {
            //闭包传递的参数
            (json) in
            //执行的代码
            print(json);
            
        })
        
          //尾随闭包，当闭包作为函数的最后一个参数时，可以省略前面的括号
        post(url: "http") { (json) in
            print(json)
        }
    
        
    }
}


//3.闭包的一些特殊用法 -- 逃逸闭包
/* 
 看起来很“吊炸天”的一个名字，其实很简单。当闭包作为一个参数传递到函数时，我们知道它一般是用于函数内部的异步回调，闭包是等异步任务完成以后才调用，而函数是会很快执行完毕并返回的，所以闭包它需要逃逸，以便稍后的回调。
 
 逃逸闭包一般用于异步函数的回调，比如网络请求成功的回调和失败的回调。语法：在函数的闭包行参前加关键字“@escaping”。
 
 或许细心的人已经发现我上面的示例网络请求为什么没有出现关键字“@escaping”，你可以拉回去看下成功回调或失败的回调，类型是“((Any?)->(Void))?”，后面带了个“？”，这是闭包可选类型，并不是闭包类型，所以无需关键字“@escaping”。
 
 假设成功和失败的回调要弄成闭包类型，而你又要异步使用的话，那就要在形参前面加关键字，如下：
 */
extension ViewController {

    /// - parameter succeed: 成功的回调  闭包 因需要异步使用，前面加关键字@escaping修饰，指明其为逃逸闭包
    /// - parameter failure: 失败的回调  闭包 因需要异步使用，前面加关键字@escaping修饰，指明其为逃逸闭包
    func requestDataEscaping(urlString:String, succeed:@escaping (Any?)->Void, failure:@escaping (Any?)->Void ){
    
        guard urlString.lengthOfBytes(using:.utf8) > 0 else {
           return
        }
        
     let request = URLRequest(url: URL(string: urlString)! )
     NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue()) { (response, data, error) in
                print(response)
                if error == nil {
                    succeed(data)
                }else{
                    failure(error)
                }
        }
        /*假设成功和失败的回调要弄成闭包类型，而你又要异步使用的话，但你又不想在形参前面加关键字，那对不起，我也没有办法，编译直接报错！*/
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestDataEscaping(urlString: "http:www.hao123.com", succeed: { (data) in
            let str = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue)
            print("============请求成功："+"\(str)")
            }) { (error) in
                print("===========error:" + "\(error)")
        }
    }
    
}
