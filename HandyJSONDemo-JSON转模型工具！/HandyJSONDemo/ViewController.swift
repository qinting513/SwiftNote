//
//  ViewController.swift
//  HandyJSONDemo
//
//  Created by Qinting on 2016/11/14.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit
import HandyJSON

//http://www.cocoachina.com/swift/20161010/17711.html

class ViewController: UIViewController {

//    可先用swiftyJSON 转化为JSON数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.testAnimal()
//        self.testCat()
//        self.testQiantao()
//        self.testNote()
//        self.testInherit()
//        self.testCustomParse()
        
        modelToJOSN()
    }

}

extension ViewController {
    
    func testAnimal() {
        let jsonString = "{\"name\":\"cat\",\"id\":\"12345\", \"num\":180}"
        
        /// 要指定类型: Animal，要不然报错 Generic parameter 'T'could not be inferred
        if let animal : Animal = JSONDeserializer.deserializeFrom(json: jsonString) {
            print(animal.name)  //注意打印出来的是可选类型 Optional("cat")
            print(animal.id)
            print(animal.num)
        }
    }

}

extension ViewController {
    
    func testCat() {
        let jsonString = "{\"id\":1234567,\"name\":\"Kitty\",\"friend\":[\"Tom\",\"Jack\",\"Lily\",\"Black\"],\"weight\":15.34,\"alive\":false,\"color\":\"white\"}"

        
        /// 要指定类型: Animal，要不然报错 Generic parameter 'T'could not be inferred
        if let cat :Cat = JSONDeserializer.deserializeFrom(json: jsonString) {
            print(cat.name)
            print(cat.friend)
            print(cat.weight)
            print(cat.alive)
        }
    }
    
}

extension ViewController {
    /// 测试嵌套
    func testQiantao(){
        let jsonString = "{\"num\":12345,\"comp1\":{\"aInt\":1,\"aString\":\"aaaaa\"},\"comp2\":{\"aInt\":2,\"aString\":\"bbbbb\"}}"
        
        if let composition : Composition = JSONDeserializer.deserializeFrom(json: jsonString) {
            print(composition.num)
            print(composition.comp1)
            
        }
    }

}

extension ViewController {
    /// 指定反序列化到某个节点
    /* 有时候服务端返回给我们的JSON文本包含了大量的状态信息，和Model无关，比如statusCode，debugMessage等，或者有用的数据是在某个节点以下，那么我们可以指定反序列化哪个节点 */
    func testNote(){
        // 服务端返回了这个JSON，我们想解析的只有data里的cat
        let jsonString = "{\"code\":200,\"msg\":\"success\",\"data\":{\"cat\":{\"id\":12345,\"name\":\"Kitty\"}}}"

        if let cat : Cat = JSONDeserializer.deserializeFrom(json: jsonString, designatedPath: "data.cat") {
           print(cat.name)
           print(cat.id)
        }
    }
    
}

extension ViewController {
   //解析有继承关系的，这个用到的也很多
    func testInherit() {
      let jsonString = "{\"id\":12345,\"color\":\"black\",\"name\":\"Animal\",\"dogName\":\"dog\",\"xxxooo\":\"fuck\"}"
        if let dog : Dog = JSONDeserializer.deserializeFrom(json: jsonString) {
           print(dog.name)
           print(dog.dogName)
           print(dog.xxx) // 随便来个属性，没值也不会报错 nil
        }
    }
}

extension ViewController {
    /* 自定义解析方式
     HandyJSON还提供了一个扩展能力，就是允许自行定义Model类某个字段的解析Key、解析方式。我们经常会有这样的需求：
     
     某个Model中，我们不想使用和服务端约定的key作为属性名，想自己定一个；
     有些类型如enum、tuple是无法直接从JSON中解析出来的，但我们在Model类中有这样的属性；
     HandyJSON协议提供了一个可选的mapping()函数，我们可以在其中指定某个字段用什么Key、或者用什么方法从JSON中解析出它的值。如我们有一个Model类和一个服务端返回的JSON串：
     */
    func testCustomParse() {
       let jsonString = "{\"mouse_id\":12345,\"name\":\"Kitty\",\"parent\":\"Tom/Lily\"}"
        if let mouse : Mouse = JSONDeserializer.deserializeFrom(json: jsonString) {
         print(mouse.name)
         print(mouse.parent)
        }
    }
}

/* ============================模型类================================ */

class Animal: HandyJSON {
    var name: String?
    var id: String?
    var num: Int?
    
    required init() {} // 如果定义是struct，连init()函数都不用声明；
}

struct Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var friend: [String]?
    var weight: Double?
    var alive: Bool = true
    var color: NSString?
}

class Dog : Animal {
    var dogName : String?
    var xxx : String?
    required init() { }
}


struct Component: HandyJSON {
    var aInt: Int?
    var aString: String?
}

struct Composition: HandyJSON {
    var num: Int?
    var comp1: Component?
    var comp2: Component?
    
}

class Mouse: HandyJSON {
    var id: Int64!
    var name: String!
    var parent: (String, String)?
    
    required init() {}
    
    //需要重写mapper方法去比配
    func mapping(mapper: HelpingMapper) {
        // 指定 id 字段用 "mouse_id" 去解析
        mapper.specify(property: &id, name: "mouse_id")
        
        // 指定 parent 字段用这个方法去解析
        mapper.specify(property: &parent) { (rawString) -> (String, String) in
            // split{$0 == "/"} 分割， map(String.init) 转化为字符串
            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
            return (parentNames[0], parentNames[1])
        }
    }
}


/* ============================ Model to JSON ================================ */
enum Gender: String {
    case Male = "male"
    case Female = "Female"
}

struct Subject {
    var id: Int64?
    var name: String?
    
    init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }
}

class Student {
    var name: String?
    var gender: Gender?
    var subjects: [Subject]?
}

extension ViewController{
    func modelToJOSN(){
        let student = Student()
        student.name = "Jack"
        student.gender = .Female
        student.subjects = [Subject(id: 1, name: "math"), Subject(id: 2, name: "English"), Subject(id: 3, name: "Philosophy")]
        
        print(JSONSerializer.serializeToJSON(object: student)!)
        print(JSONSerializer.serializeToJSON(object: student, prettify: true)!)
    
    }

}
