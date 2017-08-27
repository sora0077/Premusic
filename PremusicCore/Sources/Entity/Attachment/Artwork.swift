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
        @objc public private(set) dynamic var width: Int = 0
        @objc public private(set) dynamic var height: Int = 0

        public func url(size: Int) -> URL {
            return URL(string: _url
                .replacingOccurrences(of: "{w}", with: "\(size)")
                .replacingOccurrences(of: "{h}", with: "\(size)"))!
        }

        @objc private dynamic var _url: String = ""
        @objc private dynamic var _bgColor: String = ""
        @objc private dynamic var _textColor1: String = ""
        @objc private dynamic var _textColor2: String = ""
        @objc private dynamic var _textColor3: String = ""
        @objc private dynamic var _textColor4: String = ""

        public override class func primaryKey() -> String? { return "_url" }

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
            self.width = width
            self.height = height
            self._url = url
            self._bgColor = colors?.bgColor ?? ""
            self._textColor1 = colors?.textColor1 ?? ""
            self._textColor2 = colors?.textColor2 ?? ""
            self._textColor3 = colors?.textColor3 ?? ""
            self._textColor4 = colors?.textColor4 ?? ""
        }
    }
}
