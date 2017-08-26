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
        public typealias Attributes = GenreAttributes
        public typealias Identifier = Attributes.Identifier
        @objc public private(set) dynamic var identifier: Attributes.Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?

        public override class func primaryKey() -> String? { return "identifier" }

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes
        }
    }
}

extension Entity {
    @objc(GenreAttributes)
    public final class GenreAttributes: AttributesObject, AppleMusicKit.Genre {
        public typealias Identifier = String
        @objc fileprivate(set) dynamic var identifier: Identifier = ""

        public override class func primaryKey() -> String? { return "identifier" }

        public convenience init(id: Identifier, name: String) throws {
            self.init()
            self.identifier = id
        }
    }
}
