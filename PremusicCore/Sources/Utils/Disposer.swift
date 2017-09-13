//
//  Disposer.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/13.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import class RealmSwift.NotificationToken
import class RxSwift.DisposeBag
import protocol RxSwift.Disposable

final class Disposer {
    private var tokens: [NotificationToken] = []
    private lazy var disposeBag = DisposeBag()

    func add(_ notificationToken: NotificationToken) {
        tokens.append(notificationToken)
    }

    func add(_ disposable: Disposable) {
        disposable.disposed(by: disposeBag)
    }
}

infix operator -->: MultiplicationPrecedence
func --> (token: NotificationToken, disposer: Disposer) {
    disposer.add(token)
}
func --> (disposable: Disposable, disposer: Disposer) {
    disposer.add(disposable)
}
