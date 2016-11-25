//
//  NavVC.swift
//  YouTube
//
//  Created by Haik Aslanyan on 8/4/16.
//  Copyright © 2016 Haik Aslanyan. All rights reserved.
//

import UIKit

class NavVC: UINavigationController, PlayerVCDelegate  {

    //MARK: Properties
    lazy var playVC: PlayVC = {
        let pvc: PlayVC = self.storyboard?.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
        // 起始点 不是（0，0）
        pvc.view.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        pvc.delegate = self
        return pvc
    }()
    
    // 状态栏 上的View 透明度是0.15
    let statusView: UIView = {
        let st = UIView.init(frame: UIApplication.shared.statusBarFrame)
        st.backgroundColor = UIColor.black
        st.alpha = 0.15
        return st
    }()
    
    //隐藏的情况
        let hiddenOrigin: CGPoint = {
            // 播放时的宽度：  320 * 9/32 = 90
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    // 最小化播放的时候的起始点
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    // 全屏播放的时候的起始点
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)

    //Methods
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.playVC.view.frame.origin = self.fullScreenOrigin
                })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.playVC.view.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.playVC.view.frame.origin = self.hiddenOrigin
            })
        }
    }

    // 手势滑动的时候的宽度高度变化
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16   /// 宽高 比： 16:9
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    
    //MARK: Delegate methods
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didmaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.playVC.view.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.playVC.view.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
        case .minimized:
            self.playVC.view.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.statusView)
            window.addSubview(self.playVC.view)
        }
    }
}
