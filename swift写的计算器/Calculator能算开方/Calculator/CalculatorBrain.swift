//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Qinting on 2016/12/3.
//  Copyright © 2016年 QT. All rights reserved.
//

import Foundation

class CalculatorBrain {

    /// accumulator 累加器
    private var accumulator = 0.0
    /// 设置操作符
    func setOperand(operand:Double){
        accumulator = operand
    }
    
    ///执行运算
    func performOperation(symbol:String) {
        switch symbol {
        case "∏": accumulator = M_PI
        case "√": accumulator = sqrt(accumulator)
        default:
            break;
        }
    }
    
    var result:Double{
        get {
           return accumulator
        }
    }

}
