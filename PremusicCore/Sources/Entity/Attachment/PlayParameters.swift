//
//  PlayParameters.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(PlayParameters)
    public final class PlayParameters: Object, AppleMusicKit.PlayParameters {
        public convenience init(id: String, kind: String) throws {
            self.init()
        }
    }
}
