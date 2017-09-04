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
        @objc private(set) dynamic var updateAt = Date()
        public override class func primaryKey() -> String? { return "identifier" }

        func update() {
            updateAt = Date()
        }
    }

    @objc(AttributesObject)
    public class AttributesObject: Object {
        @objc private(set) dynamic var cachedAt = Date()
        public override class func primaryKey() -> String? { return "identifier" }
    }

    @objc(RelationsObject)
    public class RelationsObject: Object {
        public override class func primaryKey() -> String? { return "identifier" }
    }
}

protocol EntityType {
    associatedtype Attributes: AppleMusicKit.Attributes
    associatedtype Relations
    typealias Identifier = Attributes.Identifier

    var identifier: Identifier { get }
    var attributes: Attributes? { get }
    var relations: Relations! { get }

    init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes?, relations: Relations?)
}

extension EntityType {
    private static func create<R>(resource: Resource<Attributes, R>, attributes attr: Attributes?, relations: Relations?) -> Self {
        return Self.init(resource: resource, attributes: attr, relations: relations)
    }

    @discardableResult
    static func save<R>(_ resources: [Resource<Attributes, R>], to realm: Realm) -> [Self] where Self: Object, Identifier: Hashable {
        let pairs = realm.objects(Self.self)
            .filter("identifier IN %@", resources.map { $0.id })
            .map { ($0.identifier, $0) }
        let saved = Dictionary(uniqueKeysWithValues: pairs)
        let new = resources.map { create(resource: $0, attributes: saved[$0.id]?.attributes, relations: saved[$0.id]?.relations) }
        realm.add(new, update: true)
        return new
    }

    @discardableResult
    static func save<E, R>(
        type: E.Type,
        _ resources: [Resource<E.Attributes, R>],
        relationships: (R) -> [Resource<Attributes, NoRelationships>],
        to realm: Realm
    ) -> [E.Identifier: [Self]] where Self: Object, Identifier: Hashable, E: EntityType, E.Identifier: Hashable {
        var dict: [E.Identifier: [Self]] = [:]
        for r in resources {
            guard let rel = r.relationships else { continue }
            dict[r.id] = save(relationships(rel), to: realm)
        }
        return dict
    }
}
