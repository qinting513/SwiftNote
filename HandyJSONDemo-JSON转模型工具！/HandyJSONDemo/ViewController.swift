//
//  ViewController.swift
//  HandyJSONDemo
//
//  Created by Qinting on 2016/11/14.
//  Copyright © 2016年 QT. All rights reserved.
//

import UIKit
import HandyJSON

//原文：http://www.cocoachina.com/swift/20161010/17711.html
//课外阅读：[HandyJSON] 设计思路简析] http://www.cocoachina.com/swift/20161109/18010.html

class ViewController: UIViewController {

//    可先用swiftyJSON 转化为JSON数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.testAnimal()           // 简单的json
//        self.testCat()             // 稍复杂点的，各类型都有的
//        self.testQiantao()        //测试嵌套
//        self.testNote()          // 指定某个节点的
//        self.testInherit()      // 有继承关系的
//        self.testCustomParse()  // 网络返回json跟自己定义的key 需进行匹配的
        self.parseMainJson()      //解析根节点是数组的，并且有嵌套的
        
//        modelToJOSN()     //model 转 json
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

/* ======================== 模拟解析网络请求回来的数据 根节点是数组 ========================= */

/*模型类*/
class MainModel : HandyJSON {
    let clsName : String? = ""
    let title : String? = ""
    let imageName : String = ""
    let visitorInfo : VisitorInfo? = nil
    
    required init() { }
    
}

class VisitorInfo : HandyJSON {
    let imageName : String? = ""
    let message : String? = ""
    
    required init() { }
}

extension ViewController {
    /// 解析数据 方法
    func parseMainJson() {
        //        获取沙盒json
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        var  data = NSData(contentsOfFile: jsonPath)
        if data  == nil {
            //        如果沙盒里的为空 则从bundle里获取
            let   path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        //方法1: 直接将data数据转化为String
        let strData = String(data: data as! Data, encoding: String.Encoding.utf8)
        
        //方法2:  先通过SwiftyJSON将data类型序列化成JSON格式，再转成String类型，
        // 感觉方法2比方法1多绕了1步，不是很好
        let json = JSON(data:data as! Data).rawString()
        print(json)
        
        // 需要用 deserializeModelArrayFrom 解析根节点是数组的
        if let mainModelArray : [MainModel?] = JSONDeserializer.deserializeModelArrayFrom(json: strData) {
            
            for model in mainModelArray {
                if let clsName = model?.clsName,
                   let title = model?.title,    // 这样子 中间有个模块没其他数据 就没显示出来,可分条写
                   let message = model?.visitorInfo?.message {
                    print(clsName)
                    print(title)
                    print(message)
                    print("======================")
                }
            }
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
        //将Model序列化成json
        print(JSONSerializer.serializeToJSON(object: student)!)
        print(JSONSerializer.serializeToJSON(object: student, prettify: true)!)
    
    }

}
