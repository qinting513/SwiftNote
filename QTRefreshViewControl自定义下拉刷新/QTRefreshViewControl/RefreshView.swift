//
//  RefreshView.swift
//  QTRefreshViewControl
//
//  Created by Qinting on 2016/11/13.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit


class RefreshView: UIView {

    enum RefreshViewStatus {
             case normal
             case pulling
             case refreshing
    }
    
     lazy var imageView = UIImageView.init(image: UIImage(named: "rabbit_cry"))
     lazy var label = UILabel.init()
     lazy var superScrollView = UIScrollView()
     var refreshBlock:(()->())?
    
     lazy var refreshImages = [
    UIImage(named: "rabbit_loading1"),
    UIImage(named: "rabbit_loading2"),
    UIImage(named: "rabbit_loading3")
                              ]
    
    var currentStatus : RefreshViewStatus = RefreshViewStatus.normal {
        didSet {
            switch currentStatus {
//            case RefreshViewStatus.normal:
                
            case RefreshViewStatus.pulling :
                label.text = "释放刷新"
                imageView.image = UIImage(named: "rabbit_loading_error_black")
            case RefreshViewStatus.refreshing :
                label.text = "正在刷新..."
                imageView.animationImages = refreshImages as? [UIImage]
                imageView.animationDuration = 0.1*3
                imageView.startAnimating()
                UIView.animate(withDuration: 0.25, animations: { 
                   self.self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top + CGFloat(60), self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom,self.superScrollView.contentInset.right)
                });
                if (refreshBlock != nil) {
                   refreshBlock!()
                }
            default:   // normal status
                imageView.stopAnimating()
                label.text = "下拉刷新"
                imageView.image = UIImage(named: "rabbit_cry")
                superScrollView.contentInset = UIEdgeInsetsMake(CGFloat(60),0,0,0)
            }
            
        }
    }
    
    public override init(frame: CGRect) {
         super.init(frame: frame)
        imageView.frame = CGRect(x: 120, y: 5, width: 50, height: 50)
        label.frame = CGRect(x: 190, y: 20, width: 100, height: 30)
        label.text = "下拉刷新"
        label.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RefreshView {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if  (newSuperview?.isKind(of: UIScrollView.self))! {
            superScrollView = newSuperview as! UIScrollView
            superScrollView .addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if superScrollView.isDragging {
           let offsetY = superScrollView.contentOffset.y
           let normalOffsetY = -124.0
            if currentStatus == RefreshViewStatus.pulling  && offsetY > CGFloat(normalOffsetY) {
               currentStatus = .normal
            }else if currentStatus == RefreshViewStatus.normal && offsetY <= CGFloat(normalOffsetY) {
               currentStatus = .pulling
            }
        }else {
            if currentStatus == RefreshViewStatus.pulling {
                currentStatus = .refreshing
            }
        }
    }

}

/* 公共方法 */
extension RefreshView{
    public func endrefresh(){
         currentStatus = RefreshViewStatus.normal
    }
    
    /*看起来很“吊炸天”的一个名字，其实很简单。当闭包作为一个参数传递到函数时，我们知道它一般是用于函数内部的异步回调，闭包是等异步任务完成以后才调用，而函数是会很快执行完毕并返回的，所以闭包它需要逃逸，以便稍后的回调。
       逃逸闭包一般用于异步函数的回调，比如网络请求成功的回调和失败的回调。语法：在函数的闭包行参前加关键字“@escaping
     */
    public func beginRefresh(refreshBlock: @escaping ()->()){
       self.refreshBlock = refreshBlock
    }
   
   }
