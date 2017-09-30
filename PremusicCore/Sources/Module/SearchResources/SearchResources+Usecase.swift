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

    func first(where test: @escaping (_ old: Base.Element?, _ new: Base.Element?) -> Bool = { _, _  in true }) -> Observable<Base.Element?> {
        var base = Optional(self.base)
        return Observable.create { subscriber in
            var old: Base.Element?
            var token = base?.addNotificationBlock { change in
                switch change {
                case .initial(let c):
                    let first = c.first
                    subscriber.onNext(first)
                    old = first
                case .update(let c, _, _, _):
                    let first = c.first
                    if test(old, first) {
                        subscriber.onNext(first)
                    }
                    old = first
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
            return term.isEmpty
                ? .just(nil)
                : try Entity.Search.Root.objects(term: term, from: Realm())
                    .rx.first { old, new in old?.term != new?.term }
                    .flatMapLatest { $0?.songs.list.rx.observable.map { $0 } ?? .just(nil) }
        }

        func hasNextSongs(term: String) throws -> Observable<Bool> {
            return term.isEmpty
                ? .just(false)
                : try Entity.Search.Root.objects(term: term, from: Realm())
                    .rx.first { old, new in old?.term != new?.term }
                    .map { $0?.songs.request() != nil }
        }

        func searchSongs(term: String) -> Observable<Void> {
            return repos.storefront.selectedStorefront()
                .flatMapLatest { storefront in
                    storefront.read { (_, resolved) in
                        resolved.map { Observable.just($0) } ?? .empty()
                    }
                }
                .flatMapLatest { [weak self] storefront in
                    self?.repos.search.searchSongs(storefront: storefront, term: term)
                        .asObservable() ?? .never()
                }
                .catchError { error in
                    if error is AlreadyCached {
                        return .just(())
                    }
                    throw error
                }
        }
    }
}
