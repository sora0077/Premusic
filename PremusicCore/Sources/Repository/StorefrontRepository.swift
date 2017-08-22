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
    private let disposeBag = DisposeBag()

    func fetchAll() {
        locator.session.send(GetAllStorefronts()).write { (realm, page) in
            let saved = Dictionary(uniqueKeysWithValues: {
                realm.objects(Entity.Storefront.self)
                    .filter("id IN %@", page.data.map { $0.id })
                    .map { ($0.identifier, $0) }
            }())
            let new = page.data.map { Entity.Storefront(resource: $0, attributes: saved[$0.id]?.attributes) }
            realm.add(new, update: true)
        }.subscribe().disposed(by: disposeBag)
    }
}
