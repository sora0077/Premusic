//
//  SearchResources+Usecase.swift
//  PremusicCore
//
//  Created by 林 達也 on 2017/09/16.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

extension Module.SearchResources {
    final class Usecase {
        private let repos = (search: SearchRepositoryImpl(), storefront: StorefrontRepositoryImpl())

        func searchSongs(term: String) -> Observable<Void> {
            return repos.storefront.selectedStorefront()
                .flatMap { storefront in
                    storefront.read { (_, resolved) in
                        resolved.map { Observable.just($0.identifier) } ?? .never()
                    }
                }
                .flatMap { $0 }
                .flatMap { [weak self] identifier in
                    self?.repos.search.searchSongs(storefront: identifier, term: term)
                        .asObservable() ?? .never()
                }
        }
    }
}
