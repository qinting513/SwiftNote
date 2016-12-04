//
//  ViewController.swift
//  Calculator
//
//  Created by Qinting on 2016/12/3.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    ///结果显示
    @IBOutlet private weak var displayLabel: UILabel!

    /// 为了去除刚开始的0
   private var userIsInTheMiddleTyping = false
   
    ///数字按钮的点击
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleTyping {
            let textCurrentlyInDisplay = displayLabel.text
            displayLabel.text = textCurrentlyInDisplay! + digit
        }else {
            displayLabel.text = digit
        }
        userIsInTheMiddleTyping = true
    }
    
    //计算属性 存储结果值
    private var displayValue : Double {
        /// 获取值
        get{
            return Double(displayLabel.text!)!
        }
        /// 当有值的时候 给label赋值
        set {
          displayLabel.text = String(newValue)
        }
        
    }
    
    private var brain = CalculatorBrain()
    
    /// 点击了 加减乘除等运算符 按钮
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
           brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
}

