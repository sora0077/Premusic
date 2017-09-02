//
//  MusicVideo.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(MusicVideo)
    public final class MusicVideo: EntityObject, EntityType {
        public typealias Attributes = MusicVideoAttributes
        typealias Relations = MusicVideoRelations
        public typealias Identifier = Attributes.Identifier
        @objc public private(set) dynamic var identifier: Identifier = ""
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
    @objc(MusicVideoAttributes)
    public final class MusicVideoAttributes: AttributesObject, AppleMusicKit.MusicVideo {
        public typealias Identifier = String
        @objc private(set) dynamic var identifier: Identifier = ""
        @objc private(set) dynamic var artistName: String = ""
        @objc private(set) dynamic var contentRating: String?
        @objc private(set) dynamic var durationInMillis: Int = 0
        @objc private(set) dynamic var editorialNotes: EditorialNotes?
        @objc private(set) dynamic var name: String = ""

        @nonobjc private(set) var artwork: Artwork {
            get { return _artwork }
            set { _artwork = newValue }
        }
        @objc private dynamic var _artwork: Artwork!

        var entity: Entity.MusicVideo { return objects[0] }
        private let objects = LinkingObjects(fromType: Entity.MusicVideo.self, property: "attributes")

        public convenience init(
            id: Identifier,
            artistName: String,
            artwork: Artwork,
            contentRating: String?,
            durationInMillis: Int?,
            editorialNotes: EditorialNotes?,
            genreNames: [String],
            name: String,
            playParams: PlayParameters?,
            releaseDate: String,
            trackNumber: Int?,
            url: String,
            videoSubType: String?) throws {
            self.init()
            self.identifier = id
            self.artistName = artistName
            self.artwork = artwork
            self.contentRating = contentRating
            self.durationInMillis = durationInMillis ?? 0
            self.editorialNotes = editorialNotes
            self.name = name
        }
    }

    @objc(MusicVideoRelations)
    final class MusicVideoRelations: RelationsObject {
        @objc private(set) dynamic var identifier: MusicVideo.Identifier = ""

        convenience init(id: MusicVideo.Identifier) {
            self.init()
            self.identifier = id
        }
    }
}
