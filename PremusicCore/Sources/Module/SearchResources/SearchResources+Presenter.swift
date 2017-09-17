//
//  SearchResources+Presenter.swift
//  PremusicCore
//
//  Created by 林 達也 on 2017/09/16.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

public protocol SearchResourcesPresenterInput: class {

}

public protocol SearchResourcesPresenterOutput: class {
    func showSongs(_ songs: List<Entity.Song>)
    func showSongs(_ songs: List<Entity.Song>, deletions: [Int], insertions: [Int], modifications: [Int])

    func showEmpty()

}

extension Module.SearchResources {
    public final class Presenter {
        public enum Kind {
            case songs(from: String)

            var term: String {
                switch self {
                case .songs(let term): return term
                }
            }
        }
        private let usecase = Usecase()
        private let disposer = Disposer()
        private let currentTerm = PublishSubject<Kind>()

        public private(set) var songs: AnyRealmCollection<Entity.Song>!

        public init(input: SearchResourcesPresenterInput, output: SearchResourcesPresenterOutput) {

            let term = currentTerm
                .throttle(0.3, scheduler: MainScheduler.instance)
                .shareReplay(1)

            func termOrEmpty(_ kind: Kind) -> Observable<String> {
                let term = kind.term
                return !term.isEmpty ? .just(term) : .empty()
            }

            func songOrEmpty(_ kind: Kind) -> Observable<Kind> {
                switch kind {
                case .songs: return .just(kind)
                }
            }

            term.map { $0.term.isEmpty }.subscribe(onNext: { [weak self, weak output] isEmpty in
                if isEmpty {
                    self?.songs = nil
                    output?.showEmpty()
                }
            }) --> disposer

            let songTerm = term.flatMap(songOrEmpty).flatMap(termOrEmpty).shareReplay(1)

            let songSearch = songTerm.flatMapLatest { [weak self] term in
                self?.usecase.searchSongs(term: term) ?? .empty()
            }.shareReplay(1)

            Observable.combineLatest(songTerm, songSearch) { (term, _) in term }
                .flatMapLatest { [weak self] term in
                    try self?.usecase.songs(term: term).map(Observable.just) ?? .empty()
                }
                .flatMapLatest { (songs, changes) in
                    changes.map { changes in (songs, changes) }
                }
                .subscribe(onNext: { [weak self, weak output] (songs, changes) in
                    self?.songs = AnyRealmCollection(songs)
                    switch changes {
                    case .initial(let results):
                        output?.showSongs(results)
                    case .update(let results, let deletions, let insertions, let modifications):
                        output?.showSongs(results, deletions: deletions, insertions: insertions, modifications: modifications)
                    case .error:
                        break
                    }
                }) --> disposer
        }

        public func search(_ kind: Kind) {
            currentTerm.onNext(kind)
        }
    }
}
