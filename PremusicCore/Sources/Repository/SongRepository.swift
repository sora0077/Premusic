//
//  SongRepository.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/20.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import AppleMusicKit

final class SongRepositoryImpl: Repository {
    private let storefront: Entity.Storefront.Identifier

    init(storefront: Entity.Storefront.Identifier) {
        self.storefront = storefront
        super.init()
    }

    func song(with id: Entity.Song.Identifier) -> Single<Void> {
        let storefront = self.storefront
        return
            read { realm in
                realm.object(ofType: Entity.Song.Attributes.self, forPrimaryKey: id)
            }
            .flatMap { _ in
                locator.session.send(GetSong(storefront: storefront, id: id))
            }
            .write { realm, response in
                save(to: realm, with: response.data)
            }
    }

    func songs(with ids: Entity.Song.Identifier...) -> Single<Void> {
        let storefront = self.storefront
        return
            read { realm in
                realm.objects(Entity.Song.Attributes.self).filter("identifier IN %@", ids).count == ids.count
            }
            .flatMap { _ in
                locator.session.send(GetMultipleSongs(storefront: storefront, ids: ids))
            }
            .write { realm, response in
                save(to: realm, with: response.data)
            }
    }
}

private func save(to realm: Realm, with data: [Resource<Entity.Song.Attributes, GetSong.Relationships>]) {
    let songs = Entity.Song.save(data, to: realm)
    let albums = Entity.Album.save(type: Entity.Song.self, data, relationships: { $0.albums.data }, to: realm)
    let artists = Entity.Artist.save(type: Entity.Song.self, data, relationships: { $0.artists.data }, to: realm)
    let genres = Entity.Genre.save(type: Entity.Song.self, data, relationships: { $0.genres?.data ?? [] }, to: realm)
    for song in songs {
        song.relations.albums.removeAll()
        song.relations.albums.append(objectsIn: albums[song.identifier] ?? [])
        song.relations.artists.removeAll()
        song.relations.artists.append(objectsIn: artists[song.identifier] ?? [])
        song.relations.genres.removeAll()
        song.relations.genres.append(objectsIn: genres[song.identifier] ?? [])
    }
}
