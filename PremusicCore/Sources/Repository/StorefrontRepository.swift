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
    func saveSelectedStorefront(_ storefront: Entity.Storefront.Ref) -> Single<Void> {
        return storefront.write { realm, resolved in
            if let storefront = resolved {
                realm.add(Cache.SelectedStorefront(storefront), update: true)
            }
        }
    }

    func storefront(with id: Entity.Storefront.Identifier) -> Single<Void> {
        return
            read { realm in
                realm.object(ofType: Entity.Storefront.Attributes.self, forPrimaryKey: id)
            }
            .flatMap { _ in
                locator.session.send(GetStorefront(id: id, language: locator.language.identifier))
            }
            .write { realm, page in
                Entity.Storefront.save(page.data, to: realm)
            }
    }

    func storefronts(with ids: Entity.Storefront.Identifier...) -> Single<Void> {
        return
            read { realm in
                realm.objects(Entity.Storefront.Attributes.self).filter("identifier IN %@", ids).count == ids.count
            }
            .flatMap { _ in
                locator.session.send(GetMultipleStorefronts(ids: ids, language: locator.language.identifier))
            }
            .write { realm, response in
                Entity.Storefront.save(response.data, to: realm)
            }
    }

    func storefronts() -> Single<Void> {
        return
            read { realm in
                realm.object(ofType: Cache.StorefrontsCache.self, forPrimaryKey: Cache.StorefrontsCache.pk)
            }
            .flatMap { _ in
                locator.session.send(GetAllStorefronts(language: locator.language.identifier))
            }
            .write { (realm, page) in
                let data = Entity.Storefront.save(page.data, to: realm)
                realm.add(Cache.StorefrontsCache(data), update: true)
            }
    }
}
