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

private typealias SongRequest = GetCharts.GetPage<Entity.Song.Attributes>

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
            .flatMap { request -> Single<SongRequest.Response?> in
                if let request = request {
                    return locator.session.send(request).map { $0 }
                } else {
                    let request = GetCharts(storefront: storefront, types: [.songs])
                    return locator.session.send(request).map { $0.songs }
                }
            }
            .write { realm, response in
                let songs = Entity.Song.save(response?.data ?? [], to: realm)
                let chart = Entity.Chart.ChartSongs.chart(kind: kind, from: realm) ?? Entity.Chart.ChartSongs(kind: kind)
                chart.update(songs, next: response?.next, to: realm)
                realm.add(chart, update: true)
            }
    }
}

private func next(from realm: Realm, kind: Entity.Chart.Kind) throws -> SongRequest? {
    guard let chart = Entity.Chart.ChartSongs.chart(kind: kind, from: realm) else { return nil }
    guard let next = chart.request() else { throw AlreadyCached() }
    return next
}
