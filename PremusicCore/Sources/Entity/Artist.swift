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
    public final class Artist: EntityObject {
        @objc public private(set) dynamic var identifier: Attributes.Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes
        }
    }
}

extension Entity.Artist {
    @objc(ArtistAttributes)
    public final class Attributes: Object, AppleMusicKit.Artist {
        public typealias Identifier = String

        public convenience init(
            id: Identifier,
            genreNames: [String],
            editorialNotes: Entity.EditorialNotes?,
            name: String,
            url: String) throws {
            self.init()
        }
    }
}
