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

extension Observable {
    func subscribeOnNext(_ next: @escaping (E) throws -> Void) -> Disposable {
        return subscribe(onNext: { elem in
            do {
                try next(elem)
            } catch {

            }
        })
    }
}

public protocol SelectStorefrontPresenterInput: class {
    var select: Observable<ThreadSafeReference<Entity.Storefront>> { get }
}
public protocol SelectStorefrontPresenterOutput: class {
    func showStorefronts(_ storefronts: Results<Entity.Storefront>)
    func showStorefronts(_ storefronts: Results<Entity.Storefront>, deletions: [Int], insertions: [Int], modifications: [Int])

    func selectStorefront(_ storefront: Entity.Storefront)
}

extension SelectStorefront {
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

            realm.objects(Cache.SelectedStorefront.self).addNotificationBlock { [weak output] changes in
                func select(_ results: Results<Cache.SelectedStorefront>) {
                    guard let storefront = results.first?.storefront else { return }
                    output?.selectStorefront(storefront)
                }
                switch changes {
                case .initial(let results), .update(let results, _, _, _):
                    select(results)
                case .error:
                    break
                }
            } --> disposer

            input.select.subscribeOnNext { [weak self] storefront in
                try self?.usecase.select(storefront)
            } --> disposer
        }

        public func viewDidLoad() {
            usecase.listStorefronts()
        }
    }

    final class Usecase {
        private let repos = (storefront: StorefrontRepositoryImpl(), dummy: 0)
        private let disposer = Disposer()

        func listStorefronts() {
            repos.storefront.storefronts().debug().subscribe() --> disposer
        }

        func select(_ storefront: Entity.Storefront.Ref) throws {
            repos.storefront.saveSelectedStorefront(storefront).debug().subscribe() --> disposer
        }
    }
}
