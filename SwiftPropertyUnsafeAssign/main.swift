//
//  main.swift
//  SwiftPropertyAssign
//
//  Created by winddpan on 2021/5/18.
//

import Foundation

if true {
    class NSObjectClz: NSObject {
        let boolVal: Bool = false
        let stringVal: String = "str"
        let intVal: Int = 14
    }

    let object = NSObjectClz()

    print(object.intVal)
    print(object.stringVal)

    let oldVal = object.stringVal
    SwiftPropertyUnsafeAssign.unsafeAssign(object, keyPath: "stringVal", value: "aaaaa")
    print("assign stringVal: \(oldVal) -> \(object.stringVal)")

    let oldVal2 = object.intVal
    SwiftPropertyUnsafeAssign.unsafeAssign(object, keyPath: "intVal", value: 333)
    print("assign intVal: \(oldVal2) -> \(object.intVal)")
}

print("-----------")

if true {
    struct SwiftClz {
        let boolVal: Bool = false
        let stringVal: String = "str"
        let intVal: Int = 14
    }
    var object = SwiftClz()

    print(object.intVal)
    print(object.stringVal)

    let oldVal = object.stringVal
    SwiftPropertyUnsafeAssign.unsafeAssign(&object, keyPath: "stringVal", value: "aaaaa")
    print("assign stringVal: \(oldVal) -> \(object.stringVal)")

    let oldVal2 = object.intVal
    SwiftPropertyUnsafeAssign.unsafeAssign(&object, keyPath: "intVal", value: 333)
    print("assign intVal: \(oldVal2) -> \(object.intVal)")
}

print("-----------")

if true {
    class SwiftClz {
        @objc var boolVal: Bool = false
        @objc var stringVal: String = "str"
        @objc var intVal: Int = 14
    }
    let object = SwiftClz()

    print(object.intVal)
    print(object.stringVal)

    let oldVal = object.stringVal
    SwiftPropertyUnsafeAssign.unsafeAssign(object, keyPath: "stringVal", value: "aaaaa")
    print("assign stringVal: \(oldVal) -> \(object.stringVal)")

    let oldVal2 = object.intVal
    SwiftPropertyUnsafeAssign.unsafeAssign(object, keyPath: "intVal", value: 333)
    print("assign intVal: \(oldVal2) -> \(object.intVal)")
}
