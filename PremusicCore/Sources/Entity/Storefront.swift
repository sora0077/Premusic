//
//  Storefront.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

extension String: Language {}

public extension Entity {
    @objc(Storefront)
    public final class Storefront: EntityObject, EntityType {
        public typealias Attributes = StorefrontAttributes
        public typealias Identifier = Attributes.Identifier
        @objc public private(set) dynamic var identifier: Identifier = ""
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
    @objc(StorefrontAttributes)
    public final class StorefrontAttributes: AttributesObject, AppleMusicKit.Storefront {
        public typealias Language = String
        public typealias Identifier = String

        @objc fileprivate(set) dynamic var identifier: Identifier = ""

        @objc public private(set) dynamic var defaultLanguageTag: String = ""
        @objc public private(set) dynamic var name: String = ""
        public var supportedLanguageTags: [String] {
            return _supportedLanguageTags.map { $0.value }
        }
        private let _supportedLanguageTags = List<Entity.StringValue>()

        public override class func primaryKey() -> String? { return "identifier" }

        public convenience init(id: Identifier,
                                defaultLanguageTag: String,
                                name: String,
                                supportedLanguageTags: [String]) throws {
            self.init()
            self.identifier = id
            self.defaultLanguageTag = defaultLanguageTag
            self.name = name
            self._supportedLanguageTags.append(objectsIn: supportedLanguageTags.map(Entity.StringValue.init))
        }
    }
}
