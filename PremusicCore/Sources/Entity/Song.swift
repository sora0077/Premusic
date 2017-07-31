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
    public final class Song: Object {
        @objc public private(set) dynamic var identifier: Attributes.Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes
        }
    }
}

extension Entity.Song {
    @objc(SongAttributes)
    public final class Attributes: Object, AppleMusicKit.Song {
        public typealias Identifier = String

        public convenience init(
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
        }
    }
}
