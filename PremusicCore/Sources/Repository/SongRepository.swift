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
                Entity.Song.save(response.data, to: realm)
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
                Entity.Song.save(response.data, to: realm)
            }
    }
}
