//
//  SelectStorefront+Usecase.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/13.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

extension Module.SelectStorefront {
    final class Usecase {
        private let repos = (storefront: StorefrontRepositoryImpl(), dummy: 0)

        func fetch() -> Single<Void> {
            return repos.storefront.fetch()
        }

        func select(_ storefront: Entity.Storefront.Ref) -> Single<Void> {
            return repos.storefront.saveSelectedStorefront(storefront)
        }

        func selected() -> Observable<Entity.Storefront.Ref> {
            return repos.storefront.selectedStorefront()
        }

        func allStorefronts() throws -> (Results<Entity.Storefront>, CollectionChange<Entity.Storefront>) {
            let results = try repos.storefront.allStorefronts()
            return (results, repos.storefront.changes(results))
        }
    }
}
