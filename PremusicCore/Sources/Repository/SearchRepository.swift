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

private enum Value<T> {
    case value(T)
    case none

    var value: T? {
        switch self {
        case .value(let value): return value
        case .none: return nil
        }
    }

    init(_ value: T?) {
        if let value = value {
            self = .value(value)
        } else {
            self = .none
        }
    }
}

private typealias Response = (
    songs: Value<SongRequest.Response>?,
    albums: Value<AlbumRequest.Response>?,
    artist: Value<ArtistRequest.Response>?)

final class SearchRepositoryImpl: Repository {
    private let storefront: Entity.Storefront.Identifier

    init(storefront: Entity.Storefront.Identifier) {
        self.storefront = storefront
        super.init()
    }

    func searchSongs(term: String) -> Single<Void> {
        let storefront = self.storefront
        return
            next { realm in
                try nextSongs(from: realm, term: term)
            }
            .flatMap { request -> Single<Response> in
                if let request = request {
                    return locator.session.send(request).map { (Value($0), nil, nil) }
                } else {
                    let request = SearchResources(storefront: storefront, term: term)
                    return locator.session.send(request).map { (Value($0.songs), Value($0.albums), Value($0.artists)) }
                }
            }
            .write { realm, response in
                save(response, term: term, to: realm)
            }
    }

    func searchAlbums(term: String) -> Single<Void> {
        let storefront = self.storefront
        return
            next { realm in
                try nextAlbums(from: realm, term: term)
                }
                .flatMap { request -> Single<Response> in
                    if let request = request {
                        return locator.session.send(request).map { (nil, Value($0), nil) }
                    } else {
                        let request = SearchResources(storefront: storefront, term: term)
                        return locator.session.send(request).map { (Value($0.songs), Value($0.albums), Value($0.artists)) }
                    }
                }
                .write { realm, response in
                    save(response, term: term, to: realm)
                }
    }

    func searchArtists(term: String) -> Single<Void> {
        let storefront = self.storefront
        return
            next { realm in
                try nextArtists(from: realm, term: term)
            }
            .flatMap { request -> Single<Response> in
                if let request = request {
                    return locator.session.send(request).map { (nil, nil, Value($0)) }
                } else {
                    let request = SearchResources(storefront: storefront, term: term)
                    return locator.session.send(request).map { (Value($0.songs), Value($0.albums), Value($0.artists)) }
                }
            }
            .write { realm, response in
                save(response, term: term, to: realm)
            }
    }
}

private func save(_ response: Response, term: String, to realm: Realm) {
    let object = Entity.Search.SearchObject.object(term: term, from: realm) ?? .init(term: term)
    if let response = response.songs {
        let songs = Entity.Song.save(response.value?.data ?? [], to: realm)
        object.songs.update(songs, next: response.value?.next, to: realm)
    }
    if let response = response.albums {
        let albums = Entity.Album.save(response.value?.data ?? [], to: realm)
        object.albums.update(albums, next: response.value?.next, to: realm)
    }
    if let response = response.artist {
        let artists = Entity.Artist.save(response.value?.data ?? [], to: realm)
        object.artists.update(artists, next: response.value?.next, to: realm)
    }
    realm.add(object, update: true)
}

private func nextSongs(from realm: Realm, term: String) throws -> SongRequest? {
    guard let object = Entity.Search.SearchObject.object(term: term, from: realm) else { return nil }
    guard let next = object.songs.request() else { throw AlreadyCached() }
    return next
}

private func nextAlbums(from realm: Realm, term: String) throws -> AlbumRequest? {
    guard let object = Entity.Search.SearchObject.object(term: term, from: realm) else { return nil }
    guard let next = object.albums.request() else { throw AlreadyCached() }
    return next
}

private func nextArtists(from realm: Realm, term: String) throws -> ArtistRequest? {
    guard let object = Entity.Search.SearchObject.object(term: term, from: realm) else { return nil }
    guard let next = object.artists.request() else { throw AlreadyCached() }
    return next
}
