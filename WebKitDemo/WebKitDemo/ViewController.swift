//
//  ViewController.swift
//  WebKitDemo
//
//  Created by tarena on 16/1/31.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit
import WebKit

let MessageHandler = "didFetchMenus"

class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    //MARK: - IBOutlet
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    
    //MARK: - IBAction
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forwardAction(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func stopAction(_ sender: UIBarButtonItem) {
        if webView.isLoading {
            webView.stopLoading()
        }
    }
    
    //MARK: - 属性
    var menus : [Menu] = []
    var webView: WKWebView!
    
    //MARK: - 构造器
    //从storyboard中恢复(创建)当前VC对象是调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //创建WKWebView对象, 加载javascript脚本,并执行
        let configuration = WKWebViewConfiguration()
        //向configuration中注入javascript脚本
        configuration.userContentController.addUserScript(javascriptObject("hideNav"))
        configuration.userContentController.addUserScript(javascriptObject("fetchMenus"))
        //给fetchMenus增加处理器
        configuration.userContentController.add(self, name: MessageHandler)
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        
        //设置webView的导航代理
        webView.navigationDelegate = self
        
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //需要一个WKWebView
        //self.view.addSubview(webView)
        self.view.insertSubview(webView, belowSubview: progressView)
        //对webView进行布局, AutoLayout
        //别自动添加默认约束
        webView.translatesAutoresizingMaskIntoConstraints = false
        //公式: view.attr =(>=,<=) view1.attr * mult + const
        //webView.width = self.view.width * 1 + 0
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0)
        self.view.addConstraint(widthConstraint)
        //webView.height = self.view.height * 1.0 - 44
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: -44)
        self.view.addConstraint(heightConstraint)
        
        if let url = URL(string: "http://www.it007.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        //当webView的状态发生变化是,更新界面的显示   KVO
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    //MARK: - KVO
    //当监听的属性(loading, title, estimatedProgress)发生变化是调用
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {//正在加载页面
            forwardButton.isEnabled = webView.canGoForward
            backButton.isEnabled = webView.canGoBack
            stopButton.image = webView.isLoading ? UIImage(named: "Cross") : UIImage(named: "Syncing")
            self.progressView.setProgress(0.0, animated: false)
        }else if keyPath == "title" {
            title = webView.title
        }else if keyPath == "estimatedProgress" {
            self.progressView.isHidden = webView.estimatedProgress == 1
            self.progressView.setProgress(
                Float(webView.estimatedProgress), animated: true)
        }
    }
    
    //MARK: - WKScriptMessageHandler
    //当javascript传入消息时,调用此方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == MessageHandler {
            if let resultArray = message.body as? [Dictionary<String, String>] {
                menus.removeAll()
                for dict in resultArray {
                    //let url = dict["url"]
                    //let title = dict["title"]
                    //print("url:\(url),title:\(title)")
                    let m = Menu(dict: dict)
                    menus.append(m)
                }
            }
        }
    }
    
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "toMenuVCSegue" == segue.identifier {
            if let navi = segue.destination as? UINavigationController {
                if let menuVC = navi.topViewController as? MenuVC {
                    menuVC.items = self.menus
                    menuVC.selectMenuClosure = {
                        (menu:Menu) in
                        let url = URL(string: menu.url)
                        let request = URLRequest(url: url!)
                        self.webView.load(request)
                    }
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let hostname = (navigationAction.request as NSURLRequest).url?.host?.lowercased()
        if ((navigationAction.navigationType == .linkActivated) && (!hostname!.hasPrefix("http://www.it007.com"))) {
            //说明要跳转到其他网站
            //UIApplication.sharedApplication()
            //.openURL(navigationAction.request.URL!)
            webView.load(navigationAction.request)
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    }

    //MARK: - 私有方法
    //将一个javascript脚本文件包装成WKUserScript对象
    fileprivate func javascriptObject(_ filename: String)->WKUserScript! {
        if let filePath = Bundle.main.path(forResource: filename, ofType: "js") {
            if let js = try? String(contentsOfFile: filePath) {
                let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
                return userScript
            }
        }
        return nil
    }
}

