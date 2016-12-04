//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Qinting on 2016/12/3.
//  Copyright © 2016年 QT. All rights reserved.
//

import Foundation

//enum Optional<T>{
//    case None
//    case Some(T)
//}

//func multiply(op1:Double,op2:Double) -> Double {
//    return op1 * op2
//}

class CalculatorBrain {

    /// accumulator 累加器
    private var accumulator = 0.0
    /// 设置操作符
    func setOperand(operand:Double){
        accumulator = operand
    }
    
   private var operations:Dictionary<String,Operation> = [
        "∏":Operation.Constant(M_PI),
        "e":Operation.Constant(M_E),
        "√":Operation.UnaryOperation(sqrt), /// 函数指针 指向 这个函数
        "cos":Operation.UnaryOperation(cos),
        "±":Operation.UnaryOperation({-$0}),
//        "x":Operation.BinaryOperation(multiply),
        "×":Operation.BinaryOperation({ $0 * $1 }),
        "÷":Operation.BinaryOperation({ $0 / $1 }),
        "+":Operation.BinaryOperation({ $0 + $1 }),
        "−":Operation.BinaryOperation({ $0 - $1 }),
        "=":Operation.Equals
    ]
    
   private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double) //函数作为参数 (Double) -> Double
        case BinaryOperation( (Double,Double) -> Double ) // 此函数有2个参数，返回一个值
        case Equals
    
    }

    
    ///执行运算
    func performOperation(symbol:String) {
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let value):
                     accumulator = value
                case .UnaryOperation(let function):
                     accumulator = function(accumulator)
                case .BinaryOperation(let function):
                     executePendingBinaryOperation()
                     pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                case .Equals:
                     executePendingBinaryOperation()
            }
        }
        
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction((pending?.firstOperand)!, accumulator)
            pending = nil
        }
    }
    
    private var pending:PendingBinaryOperationInfo?
    private struct PendingBinaryOperationInfo {
        var binaryFunction:(Double,Double)-> Double
        var firstOperand:Double
    }
    
     var result:Double{
        get {
           return accumulator
        }
    }

}
