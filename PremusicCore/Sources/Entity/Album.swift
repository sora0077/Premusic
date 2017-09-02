//
//  Album.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(Album)
    public final class Album: EntityObject, EntityType {
        public typealias Identifier = Attributes.Identifier
        public typealias Attributes = AlbumAttributes
        typealias Relations = AlbumRelations
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
    @objc(AlbumAttributes)
    public final class AlbumAttributes: AttributesObject, AppleMusicKit.Album {
        public typealias Identifier = String
        @objc private(set) dynamic var identifier: Identifier = ""
        @objc private(set) dynamic var name: String = ""

        public convenience init(
            id: Identifier,
            artistName: String,
            artwork: Entity.Artwork,
            contentRating: String?,
            copyright: String,
            editorialNotes: Entity.EditorialNotes?,
            genreNames: [String],
            isComplete: Bool,
            isSingle: Bool,
            name: String,
            releaseDate: String,
            playParams: Entity.PlayParameters?,
            trackCount: Int,
            url: String) throws {
            self.init()
            self.identifier = id
            self.name = name
        }
    }

    @objc(AlbumRelations)
    final class AlbumRelations: RelationsObject {
        @objc private(set) dynamic var identifier: Album.Identifier = ""
        let artists = List<Entity.Artist>()
        let songs = List<Entity.Song>()
        let musicVideos = List<Entity.MusicVideo>()

        convenience init(id: Album.Identifier) {
            self.init()
            self.identifier = id
        }
    }
}
