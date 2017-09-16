//
//  Swift+Empty.swift
//  PremusicCore
//
//  Created by 林 達也 on 2017/09/16.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

public extension Optional where Wrapped == String {
    var isEmpty: Bool {
        switch self {
        case .some(let wrapped): return wrapped.isEmpty
        case .none: return true
        }
    }
}

public extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        switch self {
        case .some(let wrapped): return wrapped.isEmpty
        case .none: return true
        }
    }
}
