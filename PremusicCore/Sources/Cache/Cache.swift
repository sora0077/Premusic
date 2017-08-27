//
//  Cache.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

struct Cache {
    @objc(CacheObject)
    class CacheObject: Object {
        static let pk = "pk"
        @objc private dynamic var pk = "pk"
        @objc private(set) dynamic var cachedAt = Date()

        override class func primaryKey() -> String? { return "pk" }
    }
}
