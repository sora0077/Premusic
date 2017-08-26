//
//  Artist.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(Artist)
    public final class Artist: EntityObject, EntityType {
        public typealias Attributes = ArtistAttributes
        public typealias Identifier = Attributes.Identifier
        @objc public private(set) dynamic var identifier: Attributes.Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes
        }
    }
}

extension Entity {
    @objc(ArtistAttributes)
    public final class ArtistAttributes: AttributesObject, AppleMusicKit.Artist {
        public typealias Identifier = String
        @objc private(set) dynamic var identifier: Identifier = ""
        @objc private(set) dynamic var editorialNotes: EditorialNotes?

        public convenience init(
            id: Identifier,
            genreNames: [String],
            editorialNotes: Entity.EditorialNotes?,
            name: String,
            url: String) throws {
            self.init()
            self.identifier = id
        }
    }
}
