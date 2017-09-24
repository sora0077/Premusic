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

private final class Box<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}

extension Reactive where Base: RealmCollection, Base: AnyObject {
    var observable: Observable<RealmCollectionChange<Base>> {
        var base = Optional(self.base)
        return Observable.create { subscriber in
            var token = base?.addNotificationBlock { change in
                subscriber.onNext(change)
            }
            base = nil
            return Disposables.create {
                token?.stop()
                token = nil
            }
        }
    }

    var first: Observable<Base.Element?> {
        var base = Optional(self.base)
        return Observable.create { subscriber in
            var token = base?.addNotificationBlock { change in
                switch change {
                case .initial(let c), .update(let c, _, _, _):
                    subscriber.onNext(c.first)
                case .error: break
                }
            }
            base = nil
            return Disposables.create {
                token?.stop()
                token = nil
            }
        }
    }
}

extension Module.SearchResources {
    final class Usecase {
        private let repos = (search: SearchRepositoryImpl(), storefront: StorefrontRepositoryImpl())

        func songs(term: String) throws -> Observable<RealmCollectionChange<List<Entity.Song>>?> {
            return try Realm().objects(Entity.Search.Root.self)
                .filter("term = %@", term)
                .rx.first
                .flatMapLatest { $0?.songs.list.rx.observable.map { $0 } ?? .just(nil) }
        }

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
