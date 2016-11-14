//
//  NSObject+Parse.swift
//  HandyJSONDemo
//
//  Created by Qinting on 2016/11/14.
//  Copyright © 2016年 QT. All rights reserved.
//

import Foundation

extension NSObject {
    
    /** 只支持属性全部是 string 类型的模型,当某个属性是 NSDictionary 或者 Array 时, json[key].stringValue 会崩溃 */
    func parseData(json:JSON) {
        
        let dic = json.dictionaryValue as NSDictionary
        let keyArr:Array<String> = dic.allKeys as! Array<String>
        var propertyArr:Array<String> = []
        let hMirror = Mirror(reflecting: self)
        for case let (label?, _) in hMirror.children {
            propertyArr.append(label)
        }
        for property in propertyArr {
            for key in keyArr {
                if key == property {
                    self.setValue(json[key].stringValue, forKey: key)
                }
            }
        }
    }
    
    func parseData(json:JSON,arrayValues:Array<String>?=nil) {
        
        let dic = json.dictionaryValue as NSDictionary
        let keyArr:Array<String> = dic.allKeys as! Array<String>
        var propertyArr:Array<String> = []
        let hMirror = Mirror(reflecting: self)
        for case let (label?, _) in hMirror.children {
            propertyArr.append(label)
        }
        for property in propertyArr {
            for key in keyArr {
                if key == property {
                    for value in arrayValues! {
                        if value == property {
                            self.setValue(json[value].arrayValue, forKey: value)
                            return
                        }
                    }
                    self.setValue(json[key].stringValue, forKey: key)
                }
            }
        }
    }
    
    /** 支持任意类型 */
    func parseData(dic:NSDictionary) {
        
        print(dic)
        let keyArr:Array<String> = dic.allKeys as! Array<String>
        var propertyArr:Array<String> = []
        let hMirror = Mirror(reflecting: self)
        for case let (label?, _) in hMirror.children {
            propertyArr.append(label)
        }
        for property in propertyArr {
            for key in keyArr {
                if key == property {
                    self.setValue(dic[key], forKey: key)
                }
            }
        }
    }
}
