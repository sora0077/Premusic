//
//  DeveloperToken.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/26.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

extension Entity {
    @objc(DeveloperToken)
    final class DeveloperToken: Object {
        @objc private(set) dynamic var token: String = ""
        @objc private(set) dynamic var cachedAt = Date()

        override class func primaryKey() -> String? { return "token" }

        convenience init(token: String) {
            self.init()
            self.token = token
        }
    }
}
