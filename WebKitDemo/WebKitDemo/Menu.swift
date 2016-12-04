//
//  Menu.swift
//  WebKitDemo
//
//  Created by tarena on 16/1/31.
//  Copyright © 2016年 tarena. All rights reserved.
//  模型类Menu

class Menu {
    var title : String = ""
    var url : String = ""
    init(dict:[String: String]){
        self.title = dict["title"]!
        self.url = dict["url"]!
    }
    var description : String {
        return "title:\(title) url: \(url)"
    }
}
