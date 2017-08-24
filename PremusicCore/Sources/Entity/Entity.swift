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

        convenience init(_ value: String) {
            self.init()
            self.value = value
        }
    }

    public class EntityObject: Object {
        public override class func primaryKey() -> String? { return "identifier" }
        @objc private(set) dynamic var cachedAt = Date()

        public class AttributesObject: Object {
            public override class func primaryKey() -> String? { return "identifier" }
            @objc private(set) dynamic var cachedAt = Date()
        }
    }
}

protocol EntityType {
    associatedtype Attributes: AppleMusicKit.Attributes
    typealias Identifier = Attributes.Identifier

    var identifier: Identifier { get }
    var attributes: Attributes? { get }

    init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes?)

    static func create<R>(resource: Resource<Attributes, R>, attributes attr: Attributes?) -> Self
}

extension EntityType {
    static func create<R>(resource: Resource<Attributes, R>, attributes attr: Attributes?) -> Self {
        return Self.init(resource: resource, attributes: attr)
    }
}

func save<E: EntityType, R>(
    type: E.Type,
    _ songs: [Resource<E.Attributes, R>],
    to realm: Realm
) where E: Object, E.Identifier: Hashable {
    let saved = Dictionary(uniqueKeysWithValues: {
        realm.objects(E.self)
            .filter("id IN %@", songs.map { $0.id })
            .map { ($0.identifier, $0) }
    }())
    let new = songs.map { E.create(resource: $0, attributes: saved[$0.id]?.attributes) }
    realm.add(new, update: true)
}
