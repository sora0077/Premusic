//
//  Genre.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(Genre)
    public final class Genre: EntityObject {
        @objc public private(set) dynamic var identifier: Attributes.Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes
        }
    }
}

extension Entity.Genre {
    @objc(GenreAttributes)
    public final class Attributes: Object, AppleMusicKit.Genre {
        public typealias Identifier = String
        @objc fileprivate(set) dynamic var identifier: Identifier = ""

        public convenience init(id: Identifier, name: String) throws {
            self.init()
            self.identifier = id
        }
    }
}
