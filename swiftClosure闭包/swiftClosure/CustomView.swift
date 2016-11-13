//
//  CustomView.swift
//  swiftClosure
//
//  Created by Qinting on 2016/11/13.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit

class CustomView: UIView {

    //闭包类型 ()->() 无参数，无返回值
    var btnClickBlock:(()->())?;
    
    //重写
    override init(frame:CGRect) {
       super.init(frame: frame)
        
        let btn = UIButton(frame: CGRect(x: 15, y: 15, width: 80, height: 32));
        btn.setTitle("按钮", for: .normal)
        btn.backgroundColor=UIColor.blue
        btn.addTarget(self, action: #selector(CustomView.btnClick), for: .touchUpInside)
        addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick() {
    
        ////注意：属性btnClickBlock是可选类型，需要先解包
        if self.btnClickBlock != nil {
           self.btnClickBlock!()
        }
    }

}
