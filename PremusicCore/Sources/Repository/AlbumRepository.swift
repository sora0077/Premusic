//
//  AlbumRepository.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import AppleMusicKit

private extension Track {
    var song: Resource<Song, R>? {
        switch self {
        case .song(let song): return song
        case .musicVideo: return nil
        }
    }
    var musicVideo: Resource<MusicVideo, R>? {
        switch self {
        case .song: return nil
        case .musicVideo(let musicVideo): return musicVideo
        }
    }
}

final class AlbumRepositoryImpl: Repository {
    private let storefront: Entity.Storefront.Identifier

    init(storefront: Entity.Storefront.Identifier) {
        self.storefront = storefront
        super.init()
    }

    func album(with id: Entity.Album.Identifier) -> Single<Void> {
        let storefront = self.storefront
        return
            read { realm in
                realm.object(ofType: Entity.Album.Attributes.self, forPrimaryKey: id)
            }
            .flatMap { _ in
                locator.session.send(GetAlbum(storefront: storefront, id: id))
            }
            .write { realm, response in
                func save<T: EntityType>(
                    type: T.Type,
                    relationships: (GetAlbum.Relationships) -> [Resource<T.Attributes, NoRelationships>]
                ) -> [Entity.Album.Identifier: [T]] where T: Object, T.Attributes: Object, T.Identifier: Hashable {
                    return T.save(type: Entity.Album.self, response.data, relationships: relationships, to: realm)
                }
                let albums = Entity.Album.save(response.data, to: realm)
                let artists = save(type: Entity.Artist.self, relationships: { $0.artists.data })
                let songs = save(type: Entity.Song.self, relationships: { $0.tracks.data.flatMap { $0.song } })
                let musicVideos = save(type: Entity.MusicVideo.self, relationships: { $0.tracks.data.flatMap { $0.musicVideo } })
                for album in albums {
                    album.relations.artists.removeAll()
                    album.relations.artists.append(objectsIn: artists[album.identifier] ?? [])
                    album.relations.songs.removeAll()
                    album.relations.songs.append(objectsIn: songs[album.identifier] ?? [])
                    album.relations.musicVideos.removeAll()
                    album.relations.musicVideos.append(objectsIn: musicVideos[album.identifier] ?? [])
                }
            }
    }
}
