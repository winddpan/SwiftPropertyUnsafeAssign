//
//  SwiftPropertyAssign.swift
//  SwiftPropertyAssign
//
//  Created by winddpan on 2021/5/18.
//

import Foundation

struct SwiftPropertyUnsafeAssign {
    public static func unsafeAssign<T: AnyObject>(_ target: T, keyPath: String, value: Any) {
        let rawPointer = headPointerOfClass(target)
        if let properties = getProperties(forType: T.self) {
            let bridgedPropertyList = _getBridgedPropertyList(anyClass: T.self)
            properties.forEach { property in
                if property.key == keyPath {
                    if let nsObjet = target as? NSObject, bridgedPropertyList.contains(property.key) {
                        nsObjet.setValue(value, forKey: property.key)
                    } else {
                        let propAddr = UnsafeMutableRawPointer(mutating: rawPointer.advanced(by: property.offset))
                        extensions(of: property.type).write(value, to: propAddr)
                    }
                    return
                }
            }
        }
    }

    public static func unsafeAssign<T>(_ target: inout T, keyPath: String, value: Any) {
        let rawPointer = headPointer(&target)
        if let properties = getProperties(forType: T.self) {
            let bridgedPropertyList: Set<String>
            if let clz = T.self as? AnyClass {
                bridgedPropertyList = _getBridgedPropertyList(anyClass: clz)
            } else {
                bridgedPropertyList = []
            }
            properties.forEach { property in
                if property.key == keyPath {
                    if let nsObjet = target as? NSObject, bridgedPropertyList.contains(property.key) {
                        nsObjet.setValue(value, forKey: property.key)
                    } else {
                        let propAddr = UnsafeMutableRawPointer(mutating: rawPointer.advanced(by: property.offset))
                        extensions(of: property.type).write(value, to: propAddr)
                    }
                    return
                }
            }
        }
    }
}

private extension SwiftPropertyUnsafeAssign {
    // locate the head of a struct type object in memory
    static func headPointerOfStruct<T>(_ obj: inout T) -> UnsafeMutablePointer<Int8> {
        return withUnsafeMutablePointer(to: &obj) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: MemoryLayout<T>.stride)
        }
    }

    // locating the head of a class type object in memory
    static func headPointerOfClass<T>(_ obj: T) -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(obj as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout<T>.stride)
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }

    // locating the head of an object
    static func headPointer<T>(_ obj: inout T) -> UnsafeMutablePointer<Int8> {
        if T.self is AnyClass {
            return headPointerOfClass(obj)
        } else {
            return headPointerOfStruct(&obj)
        }
    }

    static func _getBridgedPropertyList(anyClass: AnyClass) -> Set<String> {
        if !(anyClass is NSObject.Type) {
            return []
        }
        var propertyList = Set<String>()
        if let superClass = class_getSuperclass(anyClass), superClass != NSObject.self {
            propertyList = propertyList.union(_getBridgedPropertyList(anyClass: superClass))
        }
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        if let props = class_copyPropertyList(anyClass, count) {
            for i in 0 ..< count.pointee {
                let name = String(cString: property_getName(props.advanced(by: Int(i)).pointee))
                propertyList.insert(name)
            }
            free(props)
        }
        #if swift(>=4.1)
            count.deallocate()
        #else
            count.deallocate(capacity: 1)
        #endif
        return propertyList
    }
}
