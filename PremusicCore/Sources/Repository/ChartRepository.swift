//
//  ChartRepository.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import AppleMusicKit

private struct Song {
    typealias Data = [Resource<Entity.Song.Attributes, NoRelationships>]
    typealias Next = GetCharts.GetPage<Entity.Song.Attributes>
}

final class ChartRepositoryImpl: Repository {
    private let storefront: Entity.Storefront.Identifier

    init(storefront: Entity.Storefront.Identifier) {
        self.storefront = storefront
    }

    func chart(kind: Entity.Chart.Kind = .mostPlayed) -> Single<Void> {
        let storefront = self.storefront
        return
            next { realm in
                try next(from: realm, kind: kind)
            }
            .flatMap { request -> Single<(data: Song.Data, next: Song.Next?)> in
                if let request = request {
                    return locator.session.send(request).map { ($0.data, $0.next) }
                } else {
                    return locator.session.send(GetCharts(storefront: storefront, types: [.songs]))
                        .map { ($0.songs?.data ?? [], $0.songs?.next) }
                }
            }
            .write { realm, response in
                let songs = Entity.Song.save(response.data, to: realm)
                let chart = realm.object(ofType: Entity.Chart.ChartSongs.self, forPrimaryKey: kind.rawValue)
                    ?? Entity.Chart.ChartSongs(kind: kind)
                try chart.update(songs, next: response.next)
                realm.add(chart, update: true)
            }
    }
}

private func next(from realm: Realm, kind: Entity.Chart.Kind) throws -> Song.Next? {
    guard let chart = realm.object(ofType: Entity.Chart.ChartSongs.self, forPrimaryKey: kind.rawValue) else { return nil }
    guard let next = chart.request() else { throw AlreadyCached() }
    return next
}
