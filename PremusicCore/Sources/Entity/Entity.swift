//
//  Entity.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public struct Entity {
    @objc(StringValue)
    final class StringValue: Object {
        @objc dynamic var value: String = ""

        override class func primaryKey() -> String? { return "value" }

        convenience init(_ value: String) {
            self.init()
            self.value = value
        }
    }

    @objc(EntityObject)
    public class EntityObject: Object {
        @objc private(set) dynamic var cachedAt = Date()
    }

    @objc(AttributesObject)
    public class AttributesObject: Object {
        @objc private(set) dynamic var cachedAt = Date()
    }
}

protocol EntityType {
    associatedtype Attributes: AppleMusicKit.Attributes
    typealias Identifier = Attributes.Identifier

    var identifier: Identifier { get }
    var attributes: Attributes? { get }

    init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes?)
}

extension EntityType {
    private static func create<R>(resource: Resource<Attributes, R>, attributes attr: Attributes?) -> Self {
        return Self.init(resource: resource, attributes: attr)
    }

    static func save<R>(_ resources: [Resource<Attributes, R>], to realm: Realm) where Self: Object, Identifier: Hashable {
        let pairs = realm.objects(Self.self)
            .filter("identifier IN %@", resources.map { $0.id })
            .map { ($0.identifier, $0) }
        let saved = Dictionary(uniqueKeysWithValues: pairs)
        let new = resources.map { create(resource: $0, attributes: saved[$0.id]?.attributes) }
        realm.add(new, update: true)
    }
}
