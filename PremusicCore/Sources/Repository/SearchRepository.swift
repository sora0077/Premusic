//
//  SearchRepository.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import AppleMusicKit

private typealias SongRequest = SearchResources.GetPage<Entity.Song.Attributes>
private typealias AlbumRequest = SearchResources.GetPage<Entity.Album.Attributes>
private typealias ArtistRequest = SearchResources.GetPage<Entity.Artist.Attributes>

final class SearchRepositoryImpl: Repository {
    private let storefront: Entity.Storefront.Identifier

    init(storefront: Entity.Storefront.Identifier) {
        self.storefront = storefront
        super.init()
    }

    func search(term: String) -> Single<Void> {
        let storefront = self.storefront
        return
            next { realm in
                try nextSongs(from: realm, term: term)
            }
            .flatMap { request -> Single<SongRequest.Response?> in
                if let request = request {
                    return locator.session.send(request).map { $0 }
                } else {
                    let request = SearchResources(storefront: storefront, term: term)
                    return locator.session.send(request).map { $0.songs }
                }
            }
            .write { realm, response in
                let songs = Entity.Song.save(response?.data ?? [], to: realm)
                let object = Entity.Search.SearchObject.object(term: term, from: realm) ?? .init(term: term)
                object.songs.update(songs, next: response?.next, to: realm)
                realm.add(object, update: true)
            }
    }
}

private func nextSongs(from realm: Realm, term: String) throws -> SongRequest? {
    guard let object = Entity.Search.SearchObject.object(term: term, from: realm) else { return nil }
    guard let next = object.songs.request() else { throw AlreadyCached() }
    return next
}
