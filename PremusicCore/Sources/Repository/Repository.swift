//
//  Repository.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/20.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit
import RealmSwift
import RxSwift

protocol LanguageService {
    var identifier: String { get }
}

protocol Locator {
    var session: Session { get }
    var language: LanguageService { get }

//    var subscriber:
}

extension Locale: LanguageService {}

extension Locator {
    var session: Session { return Session.shared }
    var language: LanguageService { return Locale.current }
}

let locator: Locator = LocatorImpl()

private struct LocatorImpl: Locator {
}

class Repository {
}

extension Single {
    func write<R>(_ transform: @escaping (Realm, Element) throws -> R) -> PrimitiveSequence<Trait, R> {
        return map { value in
            let realm = try Realm()
            var ret: R!
            try realm.write {
                ret = try transform(realm, value)
            }
            return ret
        }
    }
}

func realm<R>(_ transform: @escaping (Realm) throws -> R) -> Single<R> {
    return Single.create { subscriber in
        do {
            subscriber(.success(try transform(try Realm())))
        } catch {
            subscriber(.error(error))
        }
        return Disposables.create()
    }
}

extension ThreadSafeReference {
    func write<R>(_ transform: @escaping (Realm, Confined?) throws -> R) -> Single<R> {
        let ref = self
        return Single.create { subscriber in
            do {
                let realm = try Realm()
                let resolved = realm.resolve(ref)
                try realm.write {
                    subscriber(.success(try transform(realm, resolved)))
                }
            } catch {
                subscriber(.error(error))
            }
            return Disposables.create()
        }
    }
}

struct AlreadyCached: Error {}

func read<R>(_ transform: @escaping (Realm) throws -> R?) -> Single<Void> {
    return Single.create { subscriber in
        do {
            if try transform(Realm()) == nil {
                subscriber(.success(()))
            } else {
                subscriber(.error(AlreadyCached()))
            }
        } catch {
            subscriber(.error(error))
        }
        return Disposables.create()
    }
}

func read(_ transform: @escaping (Realm) throws -> Bool) -> Single<Void> {
    return Single.create { subscriber in
        do {
            if try !transform(Realm()) {
                subscriber(.success(()))
            } else {
                subscriber(.error(AlreadyCached()))
            }
        } catch {
            subscriber(.error(error))
        }
        return Disposables.create()
    }
}

func next<Req: PaginatorRequest>(_ transform: @escaping (Realm) throws -> Req?) -> Single<Req?> {
    return Single.create { subscriber in
        do {
            subscriber(.success((try transform(Realm()))))
        } catch {
            subscriber(.error(error))
        }
        return Disposables.create()
    }
}

extension Session {
    func send<Req: Request>(_ request: Req) -> Single<Req.Response> {
        return Single.create { [weak self] subscriber in
            let task = self?.send(request) { result in
                switch result {
                case .success(let response):
                    subscriber(.success(response))
                case .failure(let error):
                    subscriber(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
