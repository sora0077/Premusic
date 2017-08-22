//
//  SongRepository.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/20.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit

final class SongRepositoryImpl: Repository {
    private let storefront: Entity.Storefront.Identifier

    init(storefront: Entity.Storefront.Identifier, locator: Locator = Repository.defaultLocator) {
        self.storefront = storefront
        super.init(locator: locator)
    }

    func fetch(with id: Entity.Song.Identifier) {
        locator.session.send(GetSong(storefront: storefront, id: id)) { _ in

        }
    }
}
