//
//  Songs.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import AppleMusicKit

extension Model {
    public final class Songs {
        public static func fetch(_ identifier: Entity.Song.Identifier) -> Single<Songs?> {
            return Session.send(GetSong(storefront: "", id: ""))
                .write { _, _ in
                    return Songs()
                }
        }
    }
}
