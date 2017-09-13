//
//  Cache.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

struct Cache {
    @objc(CacheObject)
    class CacheObject: Object {
        static let pk = "pk"
        @objc private dynamic var pk = "pk"
        @objc private(set) dynamic var cachedAt = Date()

        override class func primaryKey() -> String? { return "pk" }

        static func object(from realm: Realm) -> Self? {
            return realm.object(ofType: self, forPrimaryKey: "pk")
        }
    }

    @objc(RequestObject)
    final class RequestObject: Object {
        @objc private dynamic var key: String = ""
        @objc private dynamic var path: String = ""
        @objc private dynamic var parameters: String = ""

        override class func primaryKey() -> String? { return "key" }

        convenience init?<Req: PaginatorRequest>(key: String, _ request: Req) {
            self.init()
            self.key = key
            self.path = request.path
            self.parameters = (request.parameters as? [String: Any])?.map { "\($0.key)=\($0.value)" }.joined(separator: "&") ?? ""
        }

        func request<Req: PaginatorRequest>() -> Req {
            let parameters = Dictionary(uniqueKeysWithValues: self.parameters
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .map { ($0[0], $0[1]) })
            return Req(path: path, parameters: parameters)
        }
    }
}
