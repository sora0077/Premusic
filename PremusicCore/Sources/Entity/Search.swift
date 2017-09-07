//
//  Search.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/06.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

extension Entity {
    struct Search {}
}

extension Entity.Search {
    @objc(SearchObject)
    final class SearchObject: Entity.EntityObject {
        @objc private(set) dynamic var term: String = ""
        @objc private(set) dynamic var songs: SearchSongs!

        override class func primaryKey() -> String? { return "term" }

        convenience required init(term: String) {
            self.init()
            self.term = term
            self.songs = SearchSongs(term: term)
        }

        static func object(term: String, from realm: Realm) -> SearchObject? {
            return realm.object(ofType: self, forPrimaryKey: term)
        }
    }

    @objc(SearchSongs)
    final class SearchSongs: Object, Collection {
        @objc private dynamic var term: String = ""
        private let songs = List<Entity.Song>()
        @objc private dynamic var next: Cache.RequestObject?

        convenience init(term: String) {
            self.init()
            self.term = term
        }

        func request() -> SearchResources.GetPage<Entity.Song.Attributes>? {
            return next?.request()
        }

        func update(_ songs: [Entity.Song], next: SearchResources.GetPage<Entity.Song.Attributes>?, to realm: Realm) {
            self.songs.append(objectsIn: songs)
            if let next = next.flatMap({ Cache.RequestObject(key: "SearchSongs::\(term)", $0) }) {
                realm.add(next, update: true)
                self.next = next
            } else {
                self.next = nil
            }
        }

        // MARK: Collection
        public var startIndex: Int { return songs.startIndex }
        public var endIndex: Int { return songs.endIndex }
        public func index(after idx: Int) -> Int { return songs.index(after: idx) }
        public subscript(idx: Int) -> Entity.Song { return songs[idx] }
    }
}
