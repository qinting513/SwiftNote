//
//  YahooWeatherRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/2.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class YahooWeatherRefreshHeader: UIView,RefreshableHeader{
    
    let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
    let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 14))
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        logoImage.center = CGPoint(x: self.bounds.width/2.0, y: frame.height - 30 - 7.0)
        imageView.center = CGPoint(x: self.bounds.width/2.0 - 60.0, y: frame.height - 30)
        imageView.image = UIImage(named: "sun_000000")
        logoImage.image = UIImage(named: "yahoo_logo")
        label.frame = CGRect(x: logoImage.frame.origin.x, y: logoImage.frame.origin.y + logoImage.frame.height + 2,width: 200, height: 20)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Last update: 5 minutes ago"
        addSubview(imageView)
        addSubview(logoImage)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RefreshableHeader -
    func heightForRefreshingState()->CGFloat{
        return 60
    }
    func percentUpdateDuringScrolling(_ percent: CGFloat) {
        let adjustPercent = max(min(1.0, percent),0.0)
        let index  = Int(adjustPercent * 27)
        let imageName = index < 10 ? "sun_0000\(index)" : "sun_000\(index)"
        imageView.image = UIImage(named:imageName)
    }
    func startTransitionAnimation(){
        imageView.image = UIImage(named: "sun_00073")
        let images = (27...72).map({"sun_000\($0)"}).map({UIImage(named:$0)!})
        imageView.animationImages = images
        imageView.animationDuration = Double(images.count) * 0.02
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        self.perform(#selector(YahooWeatherRefreshHeader.transitionFinihsed), with: nil, afterDelay: imageView.animationDuration)
    }
    func transitionFinihsed(){
        imageView.stopAnimating()
        let images = (73...109).map({return $0 < 100 ? "sun_000\($0)" : "sun_00\($0)"}).map({UIImage(named:$0)!})
        imageView.animationImages = images
        imageView.animationDuration = Double(images.count) * 0.03
        imageView.animationRepeatCount = 1000000
        imageView.startAnimating()
    }
    //松手即将刷新的状态
    func didBeginRefreshingState(){
        imageView.image = nil
        startTransitionAnimation()
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(_ result:RefreshResult){
        
    }
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(_ result:RefreshResult){
        imageView.stopAnimating()
        imageView.animationImages = nil
        imageView.image = UIImage(named: "sun_000000")
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(YahooWeatherRefreshHeader.transitionFinihsed), object: nil)
    }
}
