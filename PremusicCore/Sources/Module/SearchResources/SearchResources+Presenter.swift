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
    func showSongs(_ songs: List<Entity.Song>?)
    func showSongs(_ songs: List<Entity.Song>?, deletions: [Int], insertions: [Int], modifications: [Int])

    func showEmpty()

}

private func songOrEmpty(_ kind: Module.SearchResources.Presenter.Kind) -> Observable<Module.SearchResources.Presenter.Kind> {
    switch kind {
    case .songs: return .just(kind)
    }
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
                .shareReplay(1)
            observeSongs(from: term, output: output)
        }

        public func search(_ kind: Kind) {
            currentTerm.onNext(kind)
        }

        private func observeSongs(from term: Observable<Kind>, output: SearchResourcesPresenterOutput) {
            let songTerm = term
                .flatMap(songOrEmpty)
                .map { $0.term }
                .shareReplay(1)
            let songs = songTerm
                .debounce(0.2, scheduler: MainScheduler.instance)
                .flatMapLatest { [weak self] term in
                    (try self?.usecase.songs(term: term) ?? .empty()).map { (term, $0) }
                }
                .shareReplay(1)

            func checkDoRequest(songs: (term: String, results: RealmCollectionChange<List<Entity.Song>>?), term: String) -> String? {
                guard songs.term == term else { return nil }
                if case let .initial(results)? = songs.results, results.isEmpty {
                    return term
                } else if songs.results == nil {
                    return term
                } else {
                    return nil
                }
            }

            Observable
                .combineLatest(songs, songTerm, resultSelector: checkDoRequest)
                .filter { !$0.isEmpty }
                .flatMapLatest { [weak self] term in
                    term.flatMap { self?.usecase.searchSongs(term: $0) } ?? .empty()
                }
                .subscribe() --> disposer

            songs.subscribe(onNext: { [weak self, weak output] (_, changes) in
                switch changes {
                case .initial(let results)?:
                    self?.songs = AnyRealmCollection(results)
                    output?.showSongs(results)
                case .update(let results, let deletions, let insertions, let modifications)?:
                    self?.songs = AnyRealmCollection(results)
                    output?.showSongs(results, deletions: deletions, insertions: insertions, modifications: modifications)
                case .error?:
                    break
                case nil:
                    self?.songs = nil
                    output?.showSongs(nil)
                    output?.showEmpty()
                }
            }) --> disposer
        }
    }
}
