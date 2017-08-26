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
        public typealias Identifier = Attributes.Identifier
        @objc public private(set) dynamic var identifier: Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes

            switch R.self as Any {
            case is GetSong.Relationships:
                break
            default:
                break
            }
        }
    }
}

extension Entity {
    @objc(SongAttributes)
    public final class SongAttributes: AttributesObject, AppleMusicKit.Song {
        public typealias Identifier = String
        @objc fileprivate(set) dynamic var identifier: Identifier = ""

        var song: Entity.Song { return objects[0] }
        private let objects = LinkingObjects(fromType: Entity.Song.self, property: "attributes")

        public convenience init(
            id: Identifier,
            artistName: String,
            artwork: Entity.Artwork,
            composerName: String?,
            contentRating: String?,
            discNumber: Int,
            durationInMillis: Int?,
            editorialNotes: Entity.EditorialNotes?,
            genreNames: [String],
            movementCount: Int?,
            movementName: String?,
            movementNumber: Int?,
            name: String,
            playParams: Entity.PlayParameters?,
            releaseDate: String,
            trackNumber: Int,
            url: String,
            workName: String?) throws {
            self.init()
            self.identifier = id
        }
    }
}
