//
//  Model.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import APIKit
import RealmSwift
import AppleMusicKit

public struct Model {}

extension PrimitiveSequence {
    func write<R>(_ transform: @escaping (E, Realm) throws -> R) -> PrimitiveSequence<Trait, R> {
        return map { r in
            let realm = try Realm()
            var ret: R!
            try realm.write {
                ret = try transform(r, realm)
            }
            return ret
        }
    }
}

extension AppleMusicKit.Session {
    static func send<Request: AppleMusicKit.Request>(_ request: Request, callbackQueue: CallbackQueue? = nil) -> Single<Request.Response> {
        return Single.create(subscribe: { event in
            let task = send(request, callbackQueue: callbackQueue) { result in
                switch result {
                case .success(let response):
                    event(.success(response))
                case .failure(let error):
                    event(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        })
    }
    func send<Request: AppleMusicKit.Request>(_ request: Request, callbackQueue: CallbackQueue? = nil) -> Single<Request.Response> {
        return Single.create(subscribe: { [weak self] event in
            let task = self?.send(request, callbackQueue: callbackQueue) { result in
                switch result {
                case .success(let response):
                    event(.success(response))
                case .failure(let error):
                    event(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        })
    }
}
