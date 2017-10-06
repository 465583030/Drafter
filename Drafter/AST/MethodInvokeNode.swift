//
//  MethodInvokeNode.swift
//  Drafter
//
//  Created by LZephyr on 2017/9/28.
//  Copyright © 2017年 LZephyr. All rights reserved.
//

import Foundation

// MARK: - MethodInvoker

enum MethodInvoker {
    case name(String)    // 普通变量
    case method(MethodInvokeNode) // 另一个方法调用
}

// MARK: - MethodInvokeNode

/// 方法调用
class MethodInvokeNode: Node {
    var isSwift: Bool = false
    var invoker: MethodInvoker = .name("") // 方法调用方
    var params: [String] = [] // 参数, 只记录参数名称
    var methodName: String = "" // 只有解析swift用到这个属性
}

extension MethodInvokeNode {
    
    /// 找到最上层的调用者
    var topInvoker: MethodInvokeNode {
        switch invoker {
        case .name(_):
            return self
        case .method(let invoke):
            return invoke.topInvoker
        }
    }
}

extension MethodInvokeNode: CustomStringConvertible {
    var description: String {
        var method = "["
        
        switch invoker {
        case .method(let msg):
            method.append(contentsOf: "\(msg.description) ")
        case .name(let name):
            method.append(contentsOf: "\(name) ")
        }
        
        for index in 0..<params.count {
            method.append(contentsOf: "\(params[index])")
            if index != params.count - 1 {
                method.append(contentsOf: " ")
            }
        }
        
        method.append(contentsOf: "]")
        
        return method
    }
}

extension MethodInvokeNode: Hashable {
    
    static func ==(_ left: MethodInvokeNode, _ right: MethodInvokeNode) -> Bool {
        return left.hashValue == right.hashValue
    }
    
    var hashValue: Int {
        var value = ""
        for param in params {
            value.append(contentsOf: param)
        }
        return value.hashValue
    }
}
