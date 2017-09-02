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
    public final class Genre: EntityObject, EntityType {
        public typealias Attributes = GenreAttributes
        typealias Relations = GenreRelations
        public typealias Identifier = Attributes.Identifier
        @objc public private(set) dynamic var identifier: Attributes.Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?
        @objc private(set) dynamic var relations: Relations!

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil, relations rels: Relations? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes
            relations = rels ?? Relations(id: resource.id)
        }
    }
}

extension Entity {
    @objc(GenreAttributes)
    public final class GenreAttributes: AttributesObject, AppleMusicKit.Genre {
        public typealias Identifier = String
        @objc fileprivate(set) dynamic var identifier: Identifier = ""

        public convenience init(id: Identifier, name: String) throws {
            self.init()
            self.identifier = id
        }
    }

    @objc(GenreRelations)
    final class GenreRelations: RelationsObject {
        @objc private(set) dynamic var identifier: Genre.Identifier = ""

        convenience init(id: Genre.Identifier) {
            self.init()
            self.identifier = id
        }
    }
}
