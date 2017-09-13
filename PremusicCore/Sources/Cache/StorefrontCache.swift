//
//  StorefrontCache.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

extension Cache {
    @objc(SelectedStorefronts)
    final class SelectedStorefront: CacheObject {
        @objc private(set) dynamic var storefront: Entity.Storefront?

        convenience init(_ storefront: Entity.Storefront) {
            self.init()
            self.storefront = storefront
        }
    }

    @objc(StorefrontsCache)
    final class StorefrontsCache: CacheObject {
        private let list = List<Entity.Storefront>()

        convenience init(_ storefronts: [Entity.Storefront]) {
            self.init()
            list.append(objectsIn: storefronts)
        }
    }
}
