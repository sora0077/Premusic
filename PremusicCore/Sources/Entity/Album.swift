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
    public final class Album: EntityObject {
        @objc public private(set) dynamic var identifier: Attributes.Identifier = ""
        @objc public private(set) dynamic var attributes: Attributes?

        let _songs = List<Song>()

        convenience init<R>(resource: Resource<Attributes, R>, attributes attr: Attributes? = nil) {
            self.init()
            identifier = resource.id
            attributes = attr ?? resource.attributes
        }
    }
}

extension Entity.Album {
    @objc(AlbumAttributes)
    public final class Attributes: Object, AppleMusicKit.Album {
        public typealias Identifier = String
        @objc fileprivate(set) dynamic var identifier: Identifier = ""

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
        }
    }
}
