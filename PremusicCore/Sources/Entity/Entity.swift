//
//  Entity.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

public struct Entity {
    @objc(StringValue)
    final class StringValue: Object {
        @objc dynamic var value: String = ""

        convenience init(_ value: String) {
            self.init()
            self.value = value
        }
    }
}
