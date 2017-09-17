//
//  SearchResources+Presenter.swift
//  PremusicCore
//
//  Created by 林 達也 on 2017/09/16.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

extension Module.SearchResources {
    public final class Presenter {
        private let usecase = Usecase()
        private let disposer = Disposer()

        public init() {

        }

        public func searchSongs(term: String) {
            guard !term.isEmpty else { return }
            usecase.searchSongs(term: term).debug().subscribe() --> disposer
        }
    }
}
