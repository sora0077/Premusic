//
//  Storefronts.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit

extension Model {
    public final class Storefronts {
        private enum `Type` {
            case single(Entity.Storefront.Identifier)
            case all
        }
        private let type: `Type`

        public init(id: Entity.Storefront.Identifier) {
            type = .single(id)
        }

        public init() {
            type = .all
        }

        public func fetch() {
            switch type {
            case .single(let id):
                Session.send(GetStorefront(id: id))
            case .all:
                Session.send(GetAllStorefronts())
            }
        }
    }
}
