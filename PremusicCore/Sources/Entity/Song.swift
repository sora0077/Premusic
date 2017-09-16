//
//  Song.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(Song)
    public final class Song: EntityObject, EntityType {
        public typealias Attributes = SongAttributes
        typealias Relations = SongRelations
        public typealias Identifier = Attributes.Identifier
        @objc public private(set) dynamic var identifier: Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?
        @objc private(set) dynamic var relations: Relations!
        public var albums: List<Entity.Album> { return relations.albums }
        public var artists: List<Entity.Artist> { return relations.artists }
        public var genres: List<Entity.Genre> { return relations.genres }

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil, relations rels: Relations? = nil) {
            self.init()
            identifier = resource.id
            attributes = resource.attributes ?? attr
            relations = rels ?? Relations(id: resource.id)
        }
    }
}

extension Entity {
    @objc(SongAttributes)
    public final class SongAttributes: AttributesObject, AppleMusicKit.Song {
        public typealias Identifier = String
        @objc private(set) dynamic var identifier: Identifier = ""
        @objc private(set) dynamic var artistName: String = ""
        @objc private(set) dynamic var composerName: String?
        @objc private(set) dynamic var contentRating: String?
        @objc private(set) dynamic var discNumber: Int = 0
        @objc private(set) dynamic var durationInMillis: Int = 0
        @objc private(set) dynamic var editorialNotes: EditorialNotes?
        @objc private(set) dynamic var name: String = ""
        @objc private(set) dynamic var trackNumber: Int = 0

        @nonobjc private(set) var artwork: Artwork {
            get { return _artwork }
            set { _artwork = newValue }
        }
        @objc private dynamic var _artwork: Artwork!

        var song: Entity.Song { return objects[0] }
        private let objects = LinkingObjects(fromType: Entity.Song.self, property: "attributes")

        public convenience init(
            id: Identifier,
            artistName: String,
            artwork: Artwork,
            composerName: String?,
            contentRating: String?,
            discNumber: Int,
            durationInMillis: Int?,
            editorialNotes: EditorialNotes?,
            genreNames: [String],
            movementCount: Int?,
            movementName: String?,
            movementNumber: Int?,
            name: String,
            playParams: PlayParameters?,
            releaseDate: String,
            trackNumber: Int,
            url: String,
            workName: String?) throws {
            self.init()
            self.identifier = id
            self.artistName = artistName
            self.artwork = artwork
            self.composerName = composerName
            self.contentRating = contentRating
            self.discNumber = discNumber
            self.durationInMillis = durationInMillis ?? 0
            self.editorialNotes = editorialNotes
            self.name = name
            self.trackNumber = trackNumber
        }
    }

    @objc(SongRelations)
    final class SongRelations: RelationsObject {
        @objc private(set) dynamic var identifier: Song.Identifier = ""
        let albums = List<Album>()
        let artists = List<Artist>()
        let genres = List<Genre>()

        convenience init(id: Song.Identifier) {
            self.init()
            self.identifier = id
        }
    }
}
