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
                let relationships = response.data.flatMap { $0.relationships }
                Entity.Album.save(response.data, to: realm)
                Entity.Artist.save(relationships.flatMap { $0.artists.data }, to: realm)
                Entity.Song.save(relationships.flatMap { $0.tracks.data }.flatMap { $0.song }, to: realm)
                Entity.MusicVideo.save(relationships.flatMap { $0.tracks.data }.flatMap { $0.musicVideo }, to: realm)
            }
    }
}
