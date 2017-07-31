//
//  RequestAlias.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit

typealias GetSong = AppleMusicKit.GetSong<
    Entity.Song.Attributes,
    Entity.Album.Attributes,
    Entity.Artist.Attributes,
    Entity.Genre.Attributes,
    Entity.Storefront.Attributes>
