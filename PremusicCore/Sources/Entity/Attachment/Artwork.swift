//
//  Artwork.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(Artwork)
    public final class Artwork: Object, AppleMusicKit.Artwork {
        public convenience init(
            width: Int,
            height: Int,
            url: String,
            colors: (
                bgColor: String,
                textColor1: String,
                textColor2: String,
                textColor3: String,
                textColor4: String)?) throws {
            self.init()
        }
    }
}
