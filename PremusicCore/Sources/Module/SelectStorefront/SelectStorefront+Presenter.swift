//
//  SelectStorefront+Presenter.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/13.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

public protocol SelectStorefrontPresenterInput: class {
    var select: Observable<ThreadSafeReference<Entity.Storefront>> { get }
}
public protocol SelectStorefrontPresenterOutput: class {
    func showStorefronts(_ storefronts: Results<Entity.Storefront>)
    func showStorefronts(_ storefronts: Results<Entity.Storefront>, deletions: [Int], insertions: [Int], modifications: [Int])

    func selectStorefront(_ storefront: Entity.Storefront)
}

extension Module.SelectStorefront {
    public final class Presenter: PremusicCore.Presenter {
        private let usecase = Usecase()
        private let disposer = Disposer()

        public let storefronts: Results<Entity.Storefront>

        public init(input: SelectStorefrontPresenterInput, output: SelectStorefrontPresenterOutput) throws {
            let realm = try Realm()
            storefronts = realm.objects(Entity.Storefront.self).sorted(byKeyPath: "identifier")
            storefronts.addNotificationBlock { [weak output] changes in
                switch changes {
                case .initial(let results):
                    output?.showStorefronts(results)
                case .update(let results, let deletions, let insertions, let modifications):
                    output?.showStorefronts(results, deletions: deletions, insertions: insertions, modifications: modifications)
                case .error:
                    break
                }
            } --> disposer

            input.select.flatMap { [weak self] storefront in
                self?.usecase.select(storefront) ?? .never()
            }.debug().subscribe() --> disposer
        }

        public func viewWillAppear() {
            usecase.listStorefronts().debug().subscribe() --> disposer
        }
    }
}
