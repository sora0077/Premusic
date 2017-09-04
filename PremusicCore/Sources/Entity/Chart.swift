//
//  Chart.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    public struct Chart {}
}

public extension Entity.Chart {
    public enum Kind: String {
        case mostPlayed = "most-played"
    }
}

public extension Entity.Chart {
    @objc(ChartSongs)
    public final class ChartSongs: Entity.EntityObject, Collection {
        @objc private dynamic var _kind: String = ""
        @nonobjc public var kind: Kind {
            get { return Kind(rawValue: _kind)! }
            set { _kind = newValue.rawValue }
        }
        private let songs = List<Entity.Song>()
        @objc private dynamic var next: Cache.RequestObject?

        public override class func primaryKey() -> String? { return "_kind" }

        convenience init(kind: Kind) {
            self.init()
            self.kind = kind
        }

        func request() -> GetCharts.GetPage<Entity.Song.Attributes>? {
            return next?.request()
        }

        func update(_ songs: [Entity.Song], next: GetCharts.GetPage<Entity.Song.Attributes>?, to realm: Realm) throws {
            super.update()
            self.songs.append(objectsIn: songs)
            if let next = try next.flatMap({ try Cache.RequestObject(key: "ChartSongs", $0) }) {
                realm.add(next, update: true)
                self.next = next
            } else {
                self.next = nil
            }
        }

        func reset() {
            songs.removeAll()
            next = nil
        }

        // MARK: Collection
        public var startIndex: Int { return songs.startIndex }
        public var endIndex: Int { return songs.endIndex }
        public func index(after idx: Int) -> Int { return songs.index(after: idx) }
        public subscript(idx: Int) -> Entity.Song { return songs[idx] }
    }
}
