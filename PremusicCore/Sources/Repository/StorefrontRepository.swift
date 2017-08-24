//
//  StorefrontRepository.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/20.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit
import RxSwift

final class StorefrontRepositoryImpl: Repository {
    func fetch(with id: Entity.Storefront.Identifier) -> Single<Void> {
        return locator.session.send(GetStorefront(id: id)).write { realm, page in
            save(type: Entity.Storefront.self, page.data, to: realm)
        }
    }

    func fetchAll() -> Single<Void> {
        return locator.session.send(GetAllStorefronts()).write { (realm, page) in
            save(type: Entity.Storefront.self, page.data, to: realm)
        }
    }
}
