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
}

protocol Locator {
    var session: Session { get }
//    var language: LanguageService { get }

//    var subscriber:
}

extension Locator {
    var session: Session { return Session.shared }
}

private struct LocatorImpl: Locator {
}

class Repository {
    static let defaultLocator: Locator = LocatorImpl()
    let locator: Locator

    init(locator: Locator = Repository.defaultLocator) {
        self.locator = locator
    }
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
