//
//  main.swift
//  SwiftPropertyAssign
//
//  Created by winddpan on 2021/5/18.
//

import Foundation

class ClzA: NSObject {
    let boolVal: Bool = false
    let stringVal: String = "str"
    let intVal: Int = 14
}

var obj = ClzA()

print(obj.intVal)
print(obj.stringVal)


// SwiftPropertyAssign.assign(obj, keyPath: \.intVal, value: 44)
// print("assign \\.intVal", obj.intVal)
//

let oldVal = obj.stringVal
SwiftPropertyUnsafeAssign.unsafeAssign(&obj, keyPath: "stringVal", value: "aaaaa")
print("assign stringVal: \(oldVal) -> \(obj.stringVal)")

let oldVal2 = obj.intVal
SwiftPropertyUnsafeAssign.unsafeAssign(&obj, keyPath: "intVal", value: 333)
print("assign intVal: \(oldVal2) -> \(obj.intVal)")
