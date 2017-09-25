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

private func initialRequest(
    storefront: Entity.Storefront.Identifier,
    language: Entity.Storefront.Attributes.Language?,
    term: String
) -> Single<Response> {
    let request = SearchResources(storefront: storefront, term: term, language: locator.language.identifier, limit: 10)
    return locator.session.send(request).map { (Value($0.songs), Value($0.albums), Value($0.artists)) }
}

final class SearchRepositoryImpl: Repository {
    func searchSongs(storefront: Entity.Storefront, term: String) -> Single<Void> {
        let identifier = storefront.identifier
        let language = storefront.attributes?.defaultLanguageTag
        return
            next { realm in
                try nextSongs(from: realm, term: term)
            }
            .flatMap { request -> Single<Response> in
                if let request = request {
                    return locator.session.send(request).map { (Value($0), nil, nil) }
                } else {
                    return initialRequest(storefront: identifier, language: language, term: term)
                }
            }
            .write { realm, response in
                save(response, term: term, to: realm)
            }
    }

    func searchAlbums(storefront: Entity.Storefront, term: String) -> Single<Void> {
        let identifier = storefront.identifier
        let language = storefront.attributes?.defaultLanguageTag
        return
            next { realm in
                try nextAlbums(from: realm, term: term)
                }
            .flatMap { request -> Single<Response> in
                if let request = request {
                    return locator.session.send(request).map { (nil, Value($0), nil) }
                } else {
                    return initialRequest(storefront: identifier, language: language, term: term)
                }
            }
            .write { realm, response in
                save(response, term: term, to: realm)
            }
    }

    func searchArtists(storefront: Entity.Storefront, term: String) -> Single<Void> {
        let identifier = storefront.identifier
        let language = storefront.attributes?.defaultLanguageTag
        return
            next { realm in
                try nextArtists(from: realm, term: term)
            }
            .flatMap { request -> Single<Response> in
                if let request = request {
                    return locator.session.send(request).map { (nil, nil, Value($0)) }
                } else {
                    return initialRequest(storefront: identifier, language: language, term: term)
                }
            }
            .write { realm, response in
                save(response, term: term, to: realm)
            }
    }
}

private func save(_ response: Response, term: String, to realm: Realm) {
    let root = Entity.Search.Root.object(term: term, from: realm) ?? .init(term: term)
    if let response = response.songs {
        let songs = Entity.Song.save(response.value?.data ?? [], to: realm)
        root.songs.update(songs, next: response.value?.next, to: realm)
    }
    if let response = response.albums {
        let albums = Entity.Album.save(response.value?.data ?? [], to: realm)
        root.albums.update(albums, next: response.value?.next, to: realm)
    }
    if let response = response.artist {
        let artists = Entity.Artist.save(response.value?.data ?? [], to: realm)
        root.artists.update(artists, next: response.value?.next, to: realm)
    }
    realm.add(root, update: true)
}

private func nextSongs(from realm: Realm, term: String) throws -> SongRequest? {
    guard let root = Entity.Search.Root.object(term: term, from: realm) else { return nil }
    guard let next = root.songs.request() else { throw AlreadyCached() }
    return next
}

private func nextAlbums(from realm: Realm, term: String) throws -> AlbumRequest? {
    guard let root = Entity.Search.Root.object(term: term, from: realm) else { return nil }
    guard let next = root.albums.request() else { throw AlreadyCached() }
    return next
}

private func nextArtists(from realm: Realm, term: String) throws -> ArtistRequest? {
    guard let root = Entity.Search.Root.object(term: term, from: realm) else { return nil }
    guard let next = root.artists.request() else { throw AlreadyCached() }
    return next
}
