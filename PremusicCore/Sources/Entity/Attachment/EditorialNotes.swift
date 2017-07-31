//
//  EditorialNotes.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import AppleMusicKit

public extension Entity {
    @objc(EditorialNotes)
    public final class EditorialNotes: Object, AppleMusicKit.EditorialNotes {
        public convenience init(standard: String?, short: String?) throws {
            self.init()
        }
    }
}
