//
//  SongCache.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

extension Cache {
    @objc(SongCache)
    final class SongCache: CacheObject {
        let list = List<Entity.Song>()
        @objc dynamic var next: RequestObject?
    }
}
