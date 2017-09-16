//
//  SelectStorefront+Usecase.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/13.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift

extension Module.SelectStorefront {
    final class Usecase {
        private let repos = (storefront: StorefrontRepositoryImpl(), dummy: 0)

        func listStorefronts() -> Single<Void> {
            return repos.storefront.storefronts()
        }

        func select(_ storefront: Entity.Storefront.Ref) -> Single<Void> {
            return repos.storefront.saveSelectedStorefront(storefront)
        }
        
        func selected() -> Observable<Entity.Storefront.Ref> {
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
    }
}
