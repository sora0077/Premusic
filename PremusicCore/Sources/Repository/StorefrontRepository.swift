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
import RealmSwift

typealias CollectionChange<E> = Observable<RealmCollectionChange<Results<E>>> where E: Object

//protocol AAA {
//    associatedtype Element: Object
//    typealias CollectionChange = Observable<RealmCollectionChange<Results<Element>>>
//
//}

final class StorefrontRepositoryImpl: Repository {
    func saveSelectedStorefront(_ storefront: Entity.Storefront.Ref) -> Single<Void> {
        return storefront.write { realm, resolved in
            if let storefront = resolved {
                realm.add(Cache.SelectedStorefront(storefront), update: true)
            }
        }
    }

    func selectedStorefront() -> Observable<Entity.Storefront.Ref> {
        return realm { realm in
            Observable<Entity.Storefront.Ref>.create { subscriber in
                let token = realm.objects(Cache.SelectedStorefront.self).addNotificationBlock { changes in
                    func select(_ results: Results<Cache.SelectedStorefront>) {
                        guard let storefront = results.first?.storefront else { return }
                        subscriber.onNext(storefront.ref)
                    }
                    switch changes {
                    case .initial(let results), .update(let results, _, _, _):
                        select(results)
                    case .error(let error):
                        subscriber.onError(error)
                    }
                }
                return Disposables.create {
                    token.stop()
                }
            }
        }
    }

    func allStorefronts() throws -> Results<Entity.Storefront> {
        return try Realm().objects(Entity.Storefront.self).sorted(byKeyPath: "identifier", ascending: true)
    }

    func fetch(with id: Entity.Storefront.Identifier) -> Single<Void> {
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

    func fetch(with ids: Entity.Storefront.Identifier...) -> Single<Void> {
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

    func fetch() -> Single<Void> {
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
